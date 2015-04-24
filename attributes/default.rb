# rubocop:disable Metrics/LineLength

default['foreman']['path'] = '/srv/foreman'
default['foreman']['current_path'] = node['foreman']['path']
default['foreman']['version'] = 'stable'
default['foreman']['install_method'] = 'packages'
default['foreman']['use_repo'] = true
default['foreman']['config_path'] = '/etc/foreman'

default['foreman']['user'] = 'foreman'
default['foreman']['domain'] = 'example.com'

default['foreman']['syslinux']['version'] = '6.03'
default['foreman']['syslinux']['url'] = "https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{node['foreman']['syslinux']['version']}.tar.gz"
