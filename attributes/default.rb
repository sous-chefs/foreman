# rubocop:disable Metrics/LineLength
class ::Chef::Node::Attribute
  include ::Foreman
end

default['foreman']['path'] = '/usr/share/foreman'
default['foreman']['version'] = 'stable'
default['foreman']['config_path'] = '/etc/foreman'

default['foreman']['use_repo'] = true
default['foreman']['repo']['uri'] = 'http://deb.theforeman.org/'
default['foreman']['repo']['components'] = ['stable']
default['foreman']['repo']['key'] = 'http://deb.theforeman.org/foreman.asc'

default['foreman']['plugins'] = ['foreman-libvirt', 'ruby-foreman-chef','ruby-foreman-discovery']

default['foreman']['server_name'] = 'foreman.example'
default['foreman']['environment'] = 'production'

default['foreman']['admin']['username'] = 'admin'
default['foreman']['admin']['password'] = 'changeme'
default['foreman']['admin']['first_name'] = nil
default['foreman']['admin']['last_name'] = nil
default['foreman']['admin']['email'] = nil
default['foreman']['initial_organization'] = nil
default['foreman']['initial_location'] = nil

default['foreman']['user'] = 'foreman'
default['foreman']['group'] = 'foreman'
default['foreman']['group_users'] = []

default['foreman']['db']['manage'] = true
default['foreman']['db']['install'] = true
default['foreman']['db']['host'] = '127.0.0.1'
default['foreman']['db']['port'] = nil
default['foreman']['db']['adapter'] = 'postgresql'
default['foreman']['db']['real_adapter'] = case node['foreman']['db']['adapter']
                                           when 'sqlite' then
                                             'sqlite3'
                                           when 'mysql' then
                                             'mysql2'
                                           else
                                             node['foreman']['db']['adapter']
                                           end

default['foreman']['db']['ssl_mode'] = nil
default['foreman']['db']['database'] = 'foreman'
default['foreman']['db']['username'] = 'foreman'
default['foreman']['db']['password'] = 'foreman'

default['foreman']['passenger']['install'] = true
default['foreman']['passenger']['high_performance'] = true
default['foreman']['passenger']['rack_autodetect'] = false
default['foreman']['passenger']['rails_autodetect'] = false
default['foreman']['passenger']['max_pool_size'] = nil
default['foreman']['passenger']['pool_idle_time'] = nil
default['foreman']['passenger']['max_requests'] = nil
default['foreman']['passenger']['stat_throttle_rate'] = nil
default['foreman']['passenger']['use_global_queue'] = nil
default['foreman']['passenger']['default_ruby'] = nil
default['foreman']['passenger']['prestart'] = true
default['foreman']['passenger']['min_instances'] = 1
default['foreman']['passenger']['start_timeout'] = 600

case node['platform_family']
when 'rhel'
  default['foreman']['config']['init'] = '/etc/sysconfig/foreman'
  default['foreman']['config']['init_tpl'] = 'foreman.sysconfig.erb'
  default['foreman']['passenger']['ruby'] = '/usr/bin/ruby193-ruby'
  default['foreman']['passenger']['package'] = 'ruby193-rubygem-passenger-native'
when 'debian'
  default['foreman']['config']['init'] = '/etc/default/foreman'
  default['foreman']['config']['init_tpl'] = 'foreman.default.erb'
  default['foreman']['passenger']['ruby'] = '/usr/bin/ruby'
  default['foreman']['passenger']['package'] = 'libapache2-mod-passenger'
end

default['foreman']['ssl'] = true
default['foreman']['ssl_dir'] = "#{node['foreman']['config_path']}/certs"
default['foreman']['ssl_ca_file'] = "#{node['foreman']['ssl_dir']}/ca.crt"
default['foreman']['ssl_ca_key_file'] = "#{node['foreman']['ssl_dir']}/ca.key"
default['foreman']['ssl_cert_file'] = "#{node['foreman']['ssl_dir']}/server.crt"
default['foreman']['ssl_cert_key_file'] = "#{node['foreman']['ssl_dir']}/server.key"
default['foreman']['ssl_cert_csr_file'] = "#{node['foreman']['ssl_dir']}/server.csr"

default['foreman']['unattended'] = true
default['foreman']['authentication'] = true
default['foreman']['locations_enabled'] = false
default['foreman']['organizations_enabled'] = false
default['foreman']['oauth_active'] = true
default['foreman']['oauth_map_users'] = false
default['foreman']['oauth_consumer_key'] = cache_data('oauth_consumer_key', random_password)
default['foreman']['oauth_consumer_secret'] = cache_data('oauth_consumer_secret', random_password)

default['foreman']['websockets_encrypt'] = true
default['foreman']['websockets_ssl_key'] = "/etc/ssl/certs/#{node['foreman']['server_name']}.pem"
default['foreman']['websockets_ssl_cert'] = "/etc/ssl/private_keys/#{node['foreman']['server_name']}.pem"
