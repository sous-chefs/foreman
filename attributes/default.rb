default['foreman']['path'] = "/srv/foreman"
default['foreman']['current_path'] = node['foreman']['path']
default['foreman']['version'] = "1.3.0"
default['foreman']['install_method'] = "packages" #source
default['foreman']['use_repo'] = true
default['foreman']['config_path'] = "/etc/foreman"

default['foreman']['domain'] = "example.com"

default['foreman']['syslinux']['version'] = '6.02'
default['foreman']['syslinux']['url'] = "https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{node['foreman']['syslinux']['version']}.tar.gz"
