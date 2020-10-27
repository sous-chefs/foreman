#
# Cookbook:: foreman
# Recipe:: database
#
db = node['foreman']['db']
if db['manage']
  if db['adapter'] == 'mysql'
    if db['install']
      mysql_client 'default' do
        action :create
      end

      mysql_service 'default' do
        initial_root_password db['password']
        action [:create, :start]
      end

      connection_info = {
        host: '127.0.0.1',
        username: 'root',
        password: db['password'],
        socket: '/var/run/mysql-default/mysqld.sock',
      }

      mysql_database_user 'create-foremanuser' do
        username db['username']
        password db['password']
        host db['host']
        connection connection_info
        action :create
      end

      mysql_database db['database'] do
        connection connection_info
        owner db['username']
        action :create
      end

      mysql_database_user 'grant-foremanuser' do
        username db['username']
        password db['password']
        database_name db['database']
        privileges [:all]
        connection connection_info
        action :grant
      end
    end
  elsif db['adapter'] == 'postgresql'
    if db['install']
      postgresql_server_install 'PostgreSQL Server' do
        password db['password']
        initdb_locale 'en_US.utf8'
        action [:install, :create]
      end

      service 'postgresql' do
        action :nothing
      end

      postgresql_access 'PostgreSQL host superuser' do
        access_type       'local'
        access_db         'all'
        access_user       'postgres'
        access_addr       nil
        access_method     'md5'
        notifies :restart, 'service[postgresql]'
      end

      postgresql_user 'create-foremanuser' do
        create_user db['username']
        password db['password']
        superuser true
        createdb true
        action :create
      end

      postgresql_access 'PostgreSQL foreman superuser' do
        access_type       'host'
        access_db         db['database']
        access_user       db['username']
        access_addr       '127.0.0.1/32'
        access_method     'md5'
        notifies :restart, 'service[postgresql]'
      end

      postgresql_server_conf 'EDT PostgreSQL Config' do
        notifies :reload, 'service[postgresql]', :immediately
      end

      postgresql_database db['database'] do
        owner db['username']
        locale 'C.UTF-8'
        action :create
      end
    end
  end

  gem_package "activerecord-#{db['real_adapter']}-adapter"
  foreman_rake 'db:migrate'
  seed_env = {
    'SEED_ADMIN_USER' => node['foreman']['admin']['username'],
    'SEED_ADMIN_PASSWORD' => node['foreman']['admin']['password'],
    'SEED_ADMIN_FIRST_NAME' => node['foreman']['admin']['first_name'],
    'SEED_ADMIN_LAST_NAME' => node['foreman']['admin']['last_name'],
    'SEED_ADMIN_EMAIL' => node['foreman']['admin']['email'],
    'SEED_ORGANIZATION' => node['foreman']['initial_organization'],
    'SEED_LOCATION' => node['foreman']['initial_location'],
  }

  foreman_rake 'db:seed' do
    environment seed_env
  end

  foreman_rake 'apipie:cache'
end
