# rubocop:disable Metrics/LineLength

default['dhcp']['parameters']['omapi-port'] = '7911'

default['foreman-proxy']['register'] = true
default['foreman-proxy']['config_path'] = '/etc/foreman-proxy'
default['foreman-proxy']['tftproot'] = node['tftp']['directory']
default['foreman-proxy']['daemon'] = true
default['foreman-proxy']['tftp'] = true

default['foreman-proxy']['dns'] = true
default['foreman-proxy']['dhcp'] = true
default['foreman-proxy']['dhcp_vendor'] = 'isc'
default['foreman-proxy']['dhcp_config'] = node['dhcp']['config_file']
default['foreman-proxy']['dhcp_leases'] = '/var/lib/dhcp3/dhcpd.leases'

default['foreman-proxy']['puppetca'] = false

default['foreman-proxy']['dir'] = '/usr/share/foreman-proxy'
default['foreman-proxy']['user'] = 'foreman-proxy'
default['foreman-proxy']['log_path'] = '/var/log/foreman-proxy/proxy.log'
default['foreman-proxy']['log_level'] = 'ERROR'

default['foreman-proxy']['http'] = false
default['foreman-proxy']['http_port'] = '8000'
default['foreman-proxy']['https_port'] = '8443'

default['foreman-proxy']['puppet'] = false
default['foreman-proxy']['puppet_home'] = '/var/lib/puppet'
default['foreman-proxy']['puppet_url'] = "https://${::fqdn}:8140"
default['foreman-proxy']['puppet_use_environment_api'] = nil
default['foreman-proxy']['puppet_ca'] = true
default['foreman-proxy']['puppet_ca_listen_on'] = 'https'
default['foreman-proxy']['puppet_autosign_location'] = '/etc/puppet/autosign.conf'
default['foreman-proxy']['puppet_group'] = 'puppet'
default['foreman-proxy']['puppet_ssldir'] = "#{node['foreman-proxy']['puppet_home']}/ssl"

default['foreman-proxy']['ssl'] = true
default['foreman-proxy']['ssl_port'] = '8443'
default['foreman-proxy']['ssl_ca'] = "#{node['foreman-proxy']['puppet_home']}/ssl/certs/ca.pem"
default['foreman-proxy']['ssl_cert'] = "#{node['foreman-proxy']['puppet_home']}/ssl/certs/${::fqdn}.pem"
default['foreman-proxy']['ssl_key'] = "#{node['foreman-proxy']['puppet_home']}/ssl/private_keys/${::fqdn}.pem"

default['foreman-proxy']['foreman_base_url'] = "https://#{node['foreman']['server_name']}"
default['foreman-proxy']['foreman_ssl_ca'] = nil
default['foreman-proxy']['foreman_ssl_cert'] = nil
default['foreman-proxy']['foreman_ssl_key'] = nil

default['foreman-proxy']['trusted_hosts'] = [node['fqdn']]
default['foreman-proxy']['api_package'] = case node['platform_family']
                                            when 'debian'
                                            'ruby-apipie-bindings'
                                          else
                                            'rubygem-apipie-bindings'
                                          end

default['foreman-proxy']['bmc'] = false
default['foreman-proxy']['bmc_listen_on'] = 'https'
default['foreman-proxy']['bmc_default_provider'] = 'ipmitool'

default['foreman-proxy']['syslinux']['version'] = '6.03'
default['foreman-proxy']['syslinux']['url'] = "https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{default['foreman-proxy']['syslinux']['version']}.tar.gz"

default['foreman-proxy']['tftp'] = true
default['foreman-proxy']['tftp_listen_on'] = 'https'
default['foreman-proxy']['tftp_syslinux_root'] = nil
case node['platform_family']
when 'debian'
  if (node['platform'] == 'Debian' and node['platform_version'].to_f >= '8.0') or
      (node['platform'] == 'Ubuntu' and node['platform_version'].to_f >= '14.10')
    default['foreman-proxy']['tftp_syslinux_filenames'] = ['/usr/lib/PXELINUX/pxelinux.0',
                                                           '/usr/lib/syslinux/memdisk',
                                                           '/usr/lib/syslinux/modules/bios/chain.c32',
                                                           '/usr/lib/syslinux/modules/bios/ldlinux.c32',
                                                           '/usr/lib/syslinux/modules/bios/libutil.c32',
                                                           '/usr/lib/syslinux/modules/bios/menu.c32']
  else
    default['foreman-proxy']['tftp_syslinux_filenames'] = ['/usr/lib/syslinux/chain.c32',
                                                           '/usr/lib/syslinux/menu.c32',
                                                           '/usr/lib/syslinux/memdisk',
                                                           '/usr/lib/syslinux/pxelinux.0']
  end
else
  default['foreman-proxy']['tftp_syslinux_filenames'] = ['/usr/share/syslinux/chain.c32',
                                                         '/usr/share/syslinux/menu.c32',
                                                         '/usr/share/syslinux/memdisk',
                                                         '/usr/share/syslinux/pxelinux.0']
end

default['foreman-proxy']['tftp_root'] = node['tftp']['directory']
default['foreman-proxy']['tftp_dirs'] = ['pxelinux.cfg', 'boot']
default['foreman-proxy']['tftp_servername'] = nil
