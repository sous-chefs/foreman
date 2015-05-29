# include_recipe 'foreman::proxy_puppetca' if node['foreman-proxy']['puppetca']
include_recipe 'foreman::proxy_tftp' if node['foreman-proxy']['tftp']
include_recipe 'foreman::proxy_dhcp' if node['foreman-proxy']['dhcp'] &&
                                        node['foreman-proxy']['dhcp_managed']

groups = node['foreman-proxy']['group_users'].dup
if node['foreman-proxy']['dns'] && node['foreman-proxy']['dns_managed']
  include_recipe 'foreman::proxy_dns'
  groups << node['bind']['user']
end

group node['foreman-proxy']['group'] do
  members groups
end

user node['foreman-proxy']['user'] do
  shell '/bin/bash'
  group node['foreman-proxy']['group']
end

foreman_proxy_settings_file 'bmc' do
  action node['foreman-proxy']['bmc'] ? :enable : :disable
  listen_on node['foreman-proxy']['bmc_listen_on']
end

foreman_proxy_settings_file 'dhcp' do
  action node['foreman-proxy']['dhcp'] ? :enable : :disable
  listen_on node['foreman-proxy']['dhcp_listen_on']
end

foreman_proxy_settings_file 'dns' do
  action node['foreman-proxy']['dns'] ? :enable : :disable
  listen_on node['foreman-proxy']['dns_listen_on']
end

foreman_proxy_settings_file 'puppet' do
  action node['foreman-proxy']['puppetrun'] ? :enable : :disable
  listen_on node['foreman-proxy']['puppetrun_listen_on']
end

foreman_proxy_settings_file 'puppetca' do
  action node['foreman-proxy']['puppetca'] ? :enable : :disable
  listen_on node['foreman-proxy']['puppetca_listen_on']
end

foreman_proxy_settings_file 'realm' do
  action node['foreman-proxy']['realm'] ? :enable : :disable
  listen_on node['foreman-proxy']['realm_listen_on']
end

foreman_proxy_settings_file 'tftp' do
  action node['foreman-proxy']['tftp'] ? :enable : :disable
  listen_on node['foreman-proxy']['tftp_listen_on']
end

foreman_proxy_settings_file 'templates' do
  action node['foreman-proxy']['templates'] ? :enable : :disable
  listen_on node['foreman-proxy']['templates_listen_on']
end

template ::File.join(node['foreman-proxy']['config_path'], 'settings.yml') do
  group node['foreman-proxy']['group']
  source 'settings_foreman-proxy.yml.erb'
end

if node['foreman-proxy']['ssl']
  directory node['foreman-proxy']['ssl_dir'] do
    recursive true
    action :create
  end

  items = begin
            data_bag_item('foreman-proxy', node.chef_environment)
          rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
            {}
          end
  if items.key?('ssl_cert_key_file') && items.key?('ssl_cert_file') &&
      items.key?('ssl_ca_file')
    file node['foreman-proxy']['ssl_cert_key_file'] do
      content items['ssl_cert_key_file']
    end

    file node['foreman-proxy']['ssl_cert_file'] do
      content items['ssl_cert_file']
    end

    file node['foreman-proxy']['ssl_ca_file'] do
      content items['ssl_cert_file']
    end
  else
    ssl_certificate 'ca-foreman-proxy' do
      common_name 'ca.example.org'
      source 'self-signed'
      item 'ca_cert'
    end

    ssl_certificate 'foreman-proxy' do
      owner node['foreman-proxy']['user']
      group node['foreman-proxy']['group']
      source 'with_ca'
      ca_cert_path node['foreman-proxy']['ssl_ca_file']
      common_name node['foreman-proxy']['server_name']
      key_source 'self-signed'
      key_path node['foreman-proxy']['ssl_cert_key_file']
      cert_source 'self-signed'
      cert_path node['foreman-proxy']['ssl_cert_file']
    end
  end
end
