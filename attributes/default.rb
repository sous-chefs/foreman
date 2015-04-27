# rubocop:disable Metrics/LineLength

default['foreman']['path'] = '/usr/share/foreman'
default['foreman']['current_path'] = default['foreman']['path']
default['foreman']['version'] = 'stable'
default['foreman']['install_method'] = 'packages'
default['foreman']['use_repo'] = true
default['foreman']['config_path'] = '/etc/foreman'

default['foreman']['server_name'] = 'foreman.example'
default['foreman']['environment'] = 'production'

default['foreman']['user'] = 'foreman'
default['foreman']['group'] = 'foreman'
default['foreman']['manage_home'] = true
default['foreman']['group_users'] = []
default['foreman']['password'] = nil

default['foreman']['authentication'] = true
default['foreman']['passenger']['install'] = true
default['foreman']['db']['manage'] = true
default['foreman']['db']['host'] = nil
default['foreman']['db']['port'] = nil
default['foreman']['db']['adapter'] = 'postgresql'
default['foreman']['db']['database'] = nil
default['foreman']['db']['username'] = 'foreman'
default['foreman']['db']['password'] = 'foreman'

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


default['foreman']['syslinux']['version'] = '6.03'
default['foreman']['syslinux']['url'] = "https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{default['foreman']['syslinux']['version']}.tar.gz"
