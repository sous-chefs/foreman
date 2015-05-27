# rubocop:disable Metrics/LineLength
class ::Chef::Node::Attribute
  include ::Foreman
end

default['dhcp']['parameters']['omapi-port'] = '7911'

# Default config
default['foreman-proxy']['version'] = 'stable'
default['foreman-proxy']['register'] = true
default['foreman-proxy']['config_path'] = '/etc/foreman-proxy'
default['foreman-proxy']['tftproot'] = node['tftp']['directory']
default['foreman-proxy']['daemon'] = true
default['foreman-proxy']['tftp'] = true

default['foreman-proxy']['user'] = 'foreman-proxy'
default['foreman-proxy']['group'] = 'foreman-proxy'
default['foreman-proxy']['manage_home'] = true
default['foreman-proxy']['user_home'] = "/home/#{node['foreman-proxy']['user']}"
default['foreman-proxy']['group_users'] = []

# Log config
default['foreman-proxy']['log_file'] = '/var/log/foreman-proxy/proxy.log'
default['foreman-proxy']['log_level'] = 'ERROR'

# Puppet options
default['foreman-proxy']['puppetrun'] = false
default['foreman-proxy']['puppetrun_listen_on'] = 'https'

default['foreman-proxy']['puppetca'] = false
default['foreman-proxy']['puppetca_listen_on'] = 'https'
default['foreman-proxy']['puppet'] = false
default['foreman-proxy']['puppet_home'] = '/var/lib/puppet'
default['foreman-proxy']['puppet_url'] = "https://#{node['fqdn']}:8140"
default['foreman-proxy']['puppet_use_environment_api'] = nil
default['foreman-proxy']['puppet_autosign_location'] = '/etc/puppet/autosign.conf'
default['foreman-proxy']['puppet_group'] = 'puppet'
default['foreman-proxy']['puppet_ssldir'] = "#{node['foreman-proxy']['puppet_home']}/ssl"

default['foreman-proxy']['puppetssh_sudo'] = false
default['foreman-proxy']['puppetssh_command'] = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'
default['foreman-proxy']['puppetssh_user'] = 'root'
default['foreman-proxy']['puppetssh_keyfile'] = '/etc/foreman-proxy/id_rsa'
default['foreman-proxy']['puppetssh_wait'] = false

# Http(s) configuration
default['foreman-proxy']['http'] = true
default['foreman-proxy']['http_port'] = '8000'

default['foreman-proxy']['ssl'] = false
default['foreman-proxy']['https_port'] = '8443'
default['foreman-proxy']['ssl_ca'] = "#{node['foreman-proxy']['puppet_home']}/ssl/certs/ca.pem"
default['foreman-proxy']['ssl_cert'] = "#{node['foreman-proxy']['puppet_home']}/ssl/certs/#{node['fqdn']}.pem"
default['foreman-proxy']['ssl_key'] = "#{node['foreman-proxy']['puppet_home']}/ssl/private_keys/#{node['fqdn']}.pem"

default['foreman-proxy']['registered_name'] = node['fqdn']
if node['foreman-proxy']['http']
  registered_port = node['foreman-proxy']['http_port']
elsif node['foreman-proxy']['ssl']
  registered_port = node['foreman-proxy']['https_port']
end
default['foreman-proxy']['registered_proxy_url'] = "http#{'s' if node['foreman-proxy']['ssl']}://#{node['foreman-proxy']['registered_name']}:#{registered_port}"

default['foreman-proxy']['foreman_base_url'] = "http#{'s' if node['foreman']['ssl']}://#{node['foreman']['server_name']}"
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
# DNS options
default['foreman-proxy']['dns'] = true
default['foreman-proxy']['dns_listen_on'] = 'https'
default['foreman-proxy']['dns_managed'] = true
default['foreman-proxy']['dns_provider'] = 'nsupdate'
default['foreman-proxy']['dns_interface'] = 'eth0'
default['foreman-proxy']['dns_server'] = '127.0.0.1'
default['foreman-proxy']['dns_ttl'] = '86400'
default['foreman-proxy']['dns_tsig_keytab'] = '/etc/foreman-proxy/dns.keytab'
default['foreman-proxy']['dns_tsig_principal'] = "foremanproxy/#{node['fqdn']}@#{node['foreman-proxy']['dns_realm']}"
case node['platform_family']
when 'debian'
  default['foreman-proxy']['dns_keyfile'] = '/etc/bind/rndc.key'
  default['foreman-proxy']['dns_nsupdate'] = 'dnsutils'
else
  default['foreman-proxy']['dns_keyfile'] = '/etc/rndc.key'
  default['foreman-proxy']['dns_nsupdate'] = 'bind-utils'
end
default['foreman-proxy']['dns_forwarders'] = []

# DHCP options
default['foreman-proxy']['dhcp'] = true
default['foreman-proxy']['dhcp_managed'] = true
default['foreman-proxy']['dhcp_key_name'] = nil
default['foreman-proxy']['dhcp_key_secret'] = nil
default['foreman-proxy']['dhcp_vendor'] = 'isc'
default['foreman-proxy']['dhcp_config'] = node['dhcp']['config_file']
default['foreman-proxy']['dhcp_leases'] = '/var/lib/dhcp3/dhcpd.leases'

# virsh options
default['foreman-proxy']['virsh_network'] = 'default'

# BMC options
default['foreman-proxy']['bmc'] = false
default['foreman-proxy']['bmc_listen_on'] = 'https'
default['foreman-proxy']['bmc_default_provider'] = 'ipmitool'

# Syslinuyx options
default['foreman-proxy']['syslinux']['version'] = '6.03'
default['foreman-proxy']['syslinux']['url'] = "https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{default['foreman-proxy']['syslinux']['version']}.tar.gz"

# TFTP options
default['foreman-proxy']['tftp'] = true
default['foreman-proxy']['tftp_listen_on'] = 'https'
default['foreman-proxy']['tftp_syslinux_root'] = nil
case node['platform_family']
when 'debian'
  if (node['platform'] == 'Debian' && node['platform_version'].to_f >= '8.0') ||
     (node['platform'] == 'Ubuntu' && node['platform_version'].to_f >= '14.10')
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

# Realm management options
default['foreman-proxy']['realm'] = false
default['foreman-proxy']['real_listen_on'] = 'https'
default['foreman-proxy']['real_provider'] = 'freeipa'
default['foreman-proxy']['real_keytab'] = '/etc/foreman-proxy/freeipa.keytab'
default['foreman-proxy']['real_principal'] = 'realm-proxy@EXAMPLE.COM'
default['foreman-proxy']['freeipa_remove_dns'] = true

# Oauth options
default['foreman-proxy']['oauth_effective_user'] = 'admin'
default['foreman-proxy']['oauth_consumer_key'] = cache_data('oauth_consumer_key', random_password)
default['foreman-proxy']['oauth_consumer_secret'] = cache_data('oauth_consumer_secret', random_password)

# Templates options
default['foreman-proxy']['templates'] = false
default['foreman-proxy']['templates_listen_on'] = 'both'
