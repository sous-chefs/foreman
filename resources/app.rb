# frozen_string_literal: true

provides :foreman_app
unified_mode true

use '_partial/_repository'

property :server_name, String, default: 'foreman.example'
property :manage_hostname, [true, false], default: true
property :version, String
property :path, String, default: '/usr/share/foreman'
property :config_path, String, default: '/etc/foreman'
property :environment, String, default: 'production'
property :user, String, default: 'foreman'
property :group, String, default: 'foreman'
property :group_users, Array, default: []
property :manage_database, [true, false], default: true
property :database, Hash, default: {}
property :admin, Hash, default: {}
property :initial_organization, String
property :initial_location, String
property :passenger, Hash, default: {}
property :ssl_enabled, [true, false], default: true
property :ssl, Hash, default: {}
property :settings, Hash, default: {}
property :ssl_data_bag_name, String, default: 'foreman'
property :ssl_data_bag_item, String, default: lazy { node.chef_environment }

action_class do
  include ForemanCookbook::Helpers

  def merged_database
    deep_merge(
      {
        adapter: 'postgresql',
        manage: true,
        install: true,
        host: '127.0.0.1',
        port: nil,
        ssl_mode: nil,
        database: 'foreman',
        username: 'foreman',
        password: 'foreman',
        pool: nil,
      },
      symbolize_keys(new_resource.database)
    )
  end

  def merged_admin
    deep_merge(
      {
        username: 'admin',
        password: 'changeme',
        first_name: nil,
        last_name: nil,
        email: nil,
      },
      symbolize_keys(new_resource.admin)
    )
  end

  def merged_passenger
    defaults = if platform_family?('debian')
                 {
                   install: true,
                   package: 'libapache2-mod-passenger',
                   ruby: '/usr/bin/ruby',
                 }
               else
                 {
                   install: true,
                   package: nil,
                   ruby: nil,
                 }
               end

    deep_merge(
      defaults.merge(
        path: nil,
        default_ruby: nil,
        high_performance: true,
        rack_autodetect: false,
        rails_autodetect: false,
        max_pool_size: nil,
        pool_idle_time: nil,
        max_requests: nil,
        stat_throttle_rate: nil,
        use_global_queue: nil,
        min_instances: 1,
        start_timeout: 600,
        pre_start: true
      ),
      symbolize_keys(new_resource.passenger)
    )
  end

  def merged_ssl
    deep_merge(
      {
        dir: "#{new_resource.config_path}/certs",
        ca_file: "#{new_resource.config_path}/certs/ca.crt",
        ca_key_file: "#{new_resource.config_path}/certs/ca.key",
        cert_file: "#{new_resource.config_path}/certs/server.crt",
        cert_key_file: "#{new_resource.config_path}/certs/server.key",
        cert_csr_file: "#{new_resource.config_path}/certs/server.csr",
      },
      symbolize_keys(new_resource.ssl)
    )
  end

  def merged_settings
    deep_merge(
      {
        unattended: true,
        puppetconfdir: '/etc/puppet/puppet.conf',
        authentication: true,
        locations_enabled: false,
        organizations_enabled: false,
        oauth_active: true,
        oauth_map_users: false,
        oauth_consumer_key: cached_secret('oauth_consumer_key'),
        oauth_consumer_secret: cached_secret('oauth_consumer_secret'),
        websockets_encrypt: true,
        websockets_ssl_key: "/etc/ssl/certs/#{new_resource.server_name}.pem",
        websockets_ssl_cert: "/etc/ssl/private_keys/#{new_resource.server_name}.pem",
      },
      symbolize_keys(new_resource.settings)
    )
  end

  def real_adapter
    database_real_adapter(merged_database[:adapter])
  end

  def database_package
    case merged_database[:adapter]
    when 'sqlite'
      'foreman-sqlite3'
    when 'postgresql'
      'foreman-postgresql'
    when 'mysql'
      'foreman-mysql2'
    end
  end

  def init_template
    platform_family?('debian') ? 'foreman.default.erb' : 'foreman.sysconfig.erb'
  end

  def init_file_path
    platform_family?('debian') ? '/etc/default/foreman' : '/etc/sysconfig/foreman'
  end

  def ssl_data_bag_item
    data_bag_item(new_resource.ssl_data_bag_name, new_resource.ssl_data_bag_item)
  rescue StandardError
    {}
  end

  def seed_environment
    {
      'SEED_ADMIN_USER' => merged_admin[:username],
      'SEED_ADMIN_PASSWORD' => merged_admin[:password],
      'SEED_ADMIN_FIRST_NAME' => merged_admin[:first_name],
      'SEED_ADMIN_LAST_NAME' => merged_admin[:last_name],
      'SEED_ADMIN_EMAIL' => merged_admin[:email],
      'SEED_ORGANIZATION' => new_resource.initial_organization,
      'SEED_LOCATION' => new_resource.initial_location,
    }
  end

  def configure_database
    return unless merged_database[:install]

    case merged_database[:adapter]
    when 'mysql'
      mysql2_chef_gem 'default'

      mysql_client 'default' do
        action :create
      end

      mysql_service 'default' do
        initial_root_password merged_database[:password]
        action %i(create start)
      end

      connection_info = {
        host: '127.0.0.1',
        username: 'root',
        password: merged_database[:password],
        socket: '/var/run/mysql-default/mysqld.sock',
      }

      mysql_database_user 'create-foremanuser' do
        username merged_database[:username]
        password merged_database[:password]
        host merged_database[:host]
        connection connection_info
        action :create
      end

      mysql_database merged_database[:database] do
        connection connection_info
        owner merged_database[:username]
        action :create
      end

      mysql_database_user 'grant-foremanuser' do
        username merged_database[:username]
        password merged_database[:password]
        database_name merged_database[:database]
        privileges [:all]
        connection connection_info
        action :grant
      end
    when 'postgresql'
      include_root_recipe('database::postgresql')
      include_root_recipe('postgresql::server')

      connection_info = {
        host: '127.0.0.1',
        port: 5432,
        username: 'postgres',
        password: node.dig('postgresql', 'password', 'postgres'),
      }

      postgresql_database_user 'create-foremanuser' do
        username merged_database[:username]
        password merged_database[:password]
        host merged_database[:host]
        connection connection_info
        action :create
      end

      postgresql_database merged_database[:database] do
        connection connection_info
        owner merged_database[:username]
        action :create
      end

      postgresql_database_user 'grant-foremanuser' do
        username merged_database[:username]
        password merged_database[:password]
        database_name merged_database[:database]
        privileges [:all]
        connection connection_info
        action :grant
      end
    end
  end

  def write_ssl_files
    ssl_items = ssl_data_bag_item

    if ssl_items.key?('ssl_cert_key_file') && ssl_items.key?('ssl_cert_file')
      file merged_ssl[:cert_key_file] do
        content ssl_items['ssl_cert_key_file']
        sensitive true
      end

      file merged_ssl[:cert_file] do
        content ssl_items['ssl_cert_file']
      end
    else
      execute 'create-ca-key' do
        command "openssl genrsa -out #{merged_ssl[:ca_key_file]} 4096"
        not_if { ::File.exist?(merged_ssl[:ca_key_file]) }
      end

      execute 'create-ca-crt' do
        command "openssl req -new -x509 -nodes -days 1826 -key #{merged_ssl[:ca_key_file]} -out #{merged_ssl[:ca_file]} -subj '/C=US/ST=Denial/L=Springfield/O=Dis/CN=#{new_resource.server_name}'"
        not_if { ::File.exist?(merged_ssl[:ca_file]) }
      end

      execute 'create-server-key' do
        command "openssl genrsa -out #{merged_ssl[:cert_key_file]} 2048"
        not_if { ::File.exist?(merged_ssl[:cert_key_file]) }
      end

      execute 'create-server-csr' do
        command "openssl req -new -key #{merged_ssl[:cert_key_file]} -out #{merged_ssl[:cert_csr_file]} -subj '/CN=#{new_resource.server_name}'"
        not_if { ::File.exist?(merged_ssl[:cert_csr_file]) }
      end

      execute 'create-server-crt' do
        command "openssl x509 -req -in #{merged_ssl[:cert_csr_file]} -CA #{merged_ssl[:ca_file]} -CAkey #{merged_ssl[:ca_key_file]} -CAcreateserial -out #{merged_ssl[:cert_file]} -days 1826"
        not_if { ::File.exist?(merged_ssl[:cert_file]) }
      end

      execute 'update-ca-certificates' do
        command "cp #{merged_ssl[:ca_file]} /usr/share/ca-certificates/#{new_resource.server_name}.crt ; echo '#{new_resource.server_name}.crt' >> /etc/ca-certificates.conf ; update-ca-certificates -f"
        not_if { ::File.exist?("/usr/share/ca-certificates/#{new_resource.server_name}.crt") }
      end
    end
  end
end

action :install do
  if new_resource.manage_hostname
    hostname new_resource.server_name

    ohai 'reload-hostname' do
      action :reload
    end
  end

  foreman_repo 'foreman-repository' do
    repo_uri new_resource.repo_uri
    repo_key new_resource.repo_key
    repo_release new_resource.repo_release
    repo_distribution new_resource.repo_distribution
    only_if { new_resource.use_repo }
  end

  package 'foreman' do
    version new_resource.version if present?(new_resource.version)
  end

  package database_package if present?(database_package)

  apache2_install 'default'

  execute 'remove-other-vhost' do
    command 'a2disconf other-vhosts-access-log && sleep 2'
    only_if { platform_family?('debian') }
  end

  package merged_passenger[:package] do
    action :install
    only_if { merged_passenger[:install] && present?(merged_passenger[:package]) }
  end

  group new_resource.group do
    members new_resource.group_users
    append true
    only_if { present?(new_resource.group_users) }
  end

  user new_resource.user do
    shell '/bin/bash'
    group new_resource.group
  end

  directory new_resource.config_path do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  template "#{new_resource.config_path}/settings.yaml" do
    source 'settings_foreman.yaml.erb'
    group new_resource.group
    variables(
      environment: new_resource.environment,
      settings: merged_settings,
      ssl_enabled: new_resource.ssl_enabled,
      ssl: merged_ssl
    )
  end

  template "#{new_resource.config_path}/database.yml" do
    source 'database_foreman.yml.erb'
    group new_resource.group
    sensitive true
    variables(database: merged_database, real_adapter: real_adapter)
  end

  template init_file_path do
    source init_template
    variables(
      foreman_home: new_resource.path,
      foreman_user: new_resource.user,
      foreman_environment: new_resource.environment,
      passenger_install: merged_passenger[:install]
    )
  end

  if merged_passenger[:install]
    directory '/etc/apache2/05-foreman.d' do
      owner 'root'
      group 'root'
      mode '0755'
    end

    template '/etc/apache2/mods-available/passenger_extra.conf' do
      source 'passenger.conf.erb'
      variables(passenger: merged_passenger, environment: new_resource.environment)
    end

    apache2_module 'passenger'

    if new_resource.ssl_enabled
      apache2_module 'ssl'

      directory merged_ssl[:dir] do
        owner 'www-data'
        group 'www-data'
        mode '0755'
        recursive true
      end

      write_ssl_files
    end

    template '/etc/apache2/sites-available/foreman.conf' do
      source 'web_app.conf.erb'
      variables(
        params: {
          name: 'foreman',
          server_name: new_resource.server_name,
          server_aliases: ['foreman'],
          server_port: new_resource.ssl_enabled ? '443' : '80',
          docroot: "#{new_resource.path}/public",
          foreman: {
            environment: new_resource.environment,
            ssl_enabled: new_resource.ssl_enabled,
            ssl: merged_ssl,
            passenger: merged_passenger,
          },
          apache: {
            version: '2.4',
            log_dir: '/var/log/apache2',
            listen_ports: [80, 443],
          },
        },
        application_name: 'foreman'
      )
      notifies :reload, 'apache2_service[default]', :delayed
    end

    apache2_site 'foreman.conf' do
      action :enable
    end
  end

  if new_resource.manage_database && merged_database[:manage]
    configure_database

    foreman_rake 'db:migrate' do
      path new_resource.path
    end

    foreman_rake 'db:seed' do
      path new_resource.path
      environment seed_environment
    end

    foreman_rake 'apipie:cache' do
      path new_resource.path
    end
  end

  service 'foreman' do
    action %i(enable start)
  end

  apache2_service 'default' do
    action %i(enable start)
  end
end
