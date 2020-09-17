#
# Cookbook:: foreman
# Recipe:: config
#
group node['foreman']['group'] do
  members node['foreman']['group_users'] if node['foreman']['group_users']
end

user node['foreman']['user'] do
  shell '/bin/bash'
  group node['foreman']['group']
end

directory node['foreman']['config_path'] do
  owner 'root'
  group 'root'
end

template ::File.join(node['foreman']['config_path'], 'settings.yaml') do
  group node['foreman']['group']
  source 'settings_foreman.yaml.erb'
end

template ::File.join(node['foreman']['config_path'], 'database.yml') do
  group node['foreman']['group']
  source 'database_foreman.yml.erb'
  variables real_adapter: node['foreman']['db']['real_adapter']
end

template node['foreman']['config']['init'] do
  source node['foreman']['config']['init_tpl']
end

if node['foreman']['passenger']['install']
  directory "#{node['apache']['conf_dir']}/05-foreman.d" do
    owner 'root'
    group 'root'
    mode '0644'
  end

  template "#{node['apache']['dir']}/mods-available/passenger_extra.conf" do
    source 'passenger.conf.erb'
  end

  if node['foreman']['ssl']
    include_recipe 'apache2::mod_ssl'
    node.normal['apache']['listen'] = ['*:443']

    directory node['foreman']['ssl_dir'] do
      owner node['apache']['user']
      group node['apache']['group']
      recursive true
      action :create
    end

    items = begin
              data_bag_item('foreman', node.chef_environment)
            rescue Net::HTTPServerException,
                   Chef::Exceptions::ValidationFailed,
                   Chef::Exceptions::InvalidDataBagPath
              {}
            end
    if items.key?('ssl_cert_key_file') && items.key?('ssl_cert_file')
      file node['foreman']['ssl_cert_key_file'] do
        content items['ssl_cert_key_file']
      end

      file node['foreman']['ssl_cert_file'] do
        content items['ssl_cert_file']
      end
    else
      # rubocop:disable Metrics/LineLength
      execute 'create-ca-key' do
        command "openssl genrsa -out #{node['foreman']['ssl_ca_key_file']} 4096"
        not_if { ::File.exist?(node['foreman']['ssl_ca_key_file']) }
      end

      execute 'create-ca-crt' do
        command "openssl req -new -x509 -nodes -days 1826 -key #{node['foreman']['ssl_ca_key_file']} -out #{node['foreman']['ssl_ca_file']} -subj '/C=US/ST=Denial/L=Springfield/O=Dis/CN=#{node['foreman']['server_name']}'"
        not_if { ::File.exist?(node['foreman']['ssl_ca_file']) }
      end

      execute 'create-server-key' do
        command "openssl genrsa -out #{node['foreman']['ssl_cert_key_file']} 2048"
        not_if { ::File.exist?(node['foreman']['ssl_cert_key_file']) }
      end

      execute 'create-server-csr' do
        command "openssl req -new -key #{node['foreman']['ssl_cert_key_file']} -out #{node['foreman']['ssl_cert_csr_file']} -subj '/CN=#{node['foreman']['server_name']}'"
        not_if { ::File.exist?(node['foreman']['ssl_cert_csr_file']) }
      end

      execute 'create-server-crt' do
        command "openssl x509 -req -in #{node['foreman']['ssl_cert_csr_file']} -CA #{node['foreman']['ssl_ca_file']} -CAkey #{node['foreman']['ssl_ca_key_file']} -CAcreateserial -out #{node['foreman']['ssl_cert_file']} -days 1826"
        not_if { ::File.exist?(node['foreman']['ssl_cert_file']) }
      end

      execute 'update-ca-certificates' do
        command "cp #{node['foreman']['ssl_ca_file']} /usr/share/ca-certificates/#{node['foreman']['server_name']}.crt ; " \
        "echo '#{node['foreman']['server_name']}.crt' >> /etc/ca-certificates.conf ; " \
        'update-ca-certificates -f'
        not_if { ::File.exist?("/usr/share/ca-certificates/#{node['foreman']['server_name']}.crt") }
      end
      # rubocop:enable Metrics/LineLength
    end
  end

  web_app 'foreman' do
    server_name node['foreman']['server_name']
    server_aliases ['foreman']
    if node['foreman']['ssl']
      server_port '443'
    else
      server_port '80'
    end
    docroot "#{node['foreman']['path']}/public"
    directory_options %w(SymLinksIfOwnerMatch)
    cookbook 'foreman'
    notifies :service[apache2], :restart, :immediately
  end
end
