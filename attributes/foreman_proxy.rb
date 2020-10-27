class ::Chef::Node::Attribute
  include ::Foreman
end

# Default config
default['foreman-proxy']['version'] = 'stable'
default['foreman-proxy']['register'] = true
default['foreman-proxy']['config_path'] = '/etc/foreman-proxy'
default['foreman-proxy']['daemon'] = true

default['foreman-proxy']['user'] = 'foreman-proxy'
default['foreman-proxy']['group'] = 'foreman-proxy'
default['foreman-proxy']['group_users'] = []

default['foreman-proxy']['plugins'] = %w(ruby-smart-proxy-chef ruby-smart-proxy-discovery)

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
default['foreman-proxy']['puppet_url'] = "https://#{node['foreman']['server_name']}:8140"
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
default['foreman-proxy']['http'] = false
default['foreman-proxy']['http_port'] = '8000'

default['foreman-proxy']['ssl'] = true
default['foreman-proxy']['https_port'] = '8443'
default['foreman-proxy']['ssl_ca_file'] = node['foreman']['ssl_ca_file']
default['foreman-proxy']['ssl_cert_file'] = node['foreman']['ssl_cert_file']
default['foreman-proxy']['ssl_cert_key_file'] = node['foreman']['ssl_cert_key_file']

default['foreman-proxy']['registered_name'] = node['fqdn']
if node['foreman-proxy']['http']
  registered_port = node['foreman-proxy']['http_port']
elsif node['foreman-proxy']['ssl']
  registered_port = node['foreman-proxy']['https_port']
end
default['foreman-proxy']['registered_proxy_url'] = "http#{'s' if node['foreman-proxy']['ssl']}://#{node['foreman-proxy']['registered_name']}:#{registered_port}"

default['foreman-proxy']['foreman_base_url'] = "http#{'s' if node['foreman']['ssl']}://#{node['foreman']['server_name']}"
default['foreman-proxy']['foreman_ssl_ca'] = node['foreman']['ssl_ca_file']
default['foreman-proxy']['foreman_ssl_cert'] = node['foreman']['ssl_cert_file']
default['foreman-proxy']['foreman_ssl_key'] = node['foreman']['ssl_cert_key_file']

default['foreman-proxy']['trusted_hosts'] = [node['foreman']['server_name']]
default['foreman-proxy']['api_package'] = if platform_family?('debian')
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
default['foreman-proxy']['dns_realm'] = node['fqdn'].nil? ? '' : node['fqdn'].upcase
default['foreman-proxy']['dns_tsig_keytab'] = '/etc/foreman-proxy/dns.keytab'
default['foreman-proxy']['dns_tsig_principal'] = "foremanproxy/#{node['fqdn']}@#{node['foreman-proxy']['dns_realm']}"
if platform_family?('debian')
  default['foreman-proxy']['dns_keyfile'] = '/etc/bind/rndc.key'
  default['foreman-proxy']['dns_nsupdate'] = 'dnsutils'
else
  default['foreman-proxy']['dns_keyfile'] = '/etc/rndc.key'
  default['foreman-proxy']['dns_nsupdate'] = 'bind-utils'
end

# DHCP proxy (subnet) options
default['foreman-proxy']['dhcp'] = true
default['foreman-proxy']['dhcp_managed'] = true
default['foreman-proxy']['dhcp_key_name'] = nil
default['foreman-proxy']['dhcp_key_secret'] = nil
default['foreman-proxy']['dhcp_vendor'] = 'isc'
default['foreman-proxy']['dhcp_config'] = node['dhcp']['config_file']
default['foreman-proxy']['dhcp_leases'] = '/var/lib/dhcp/dhcpd.leases'
default['foreman-proxy']['dhcp_interface'] = 'eth0'
net = node['network']['interfaces'][node['foreman-proxy']['dhcp_interface']]
ip_addr = net['addresses'].keys.select { |a| a[/\A\d+\.\d+\.\d+\.\d+\Z/] }.first
default['foreman-proxy']['ip'] = ip_addr
route = net['routes'].find { |ip| ip.key?('src') && ip['src'] == ip_addr }.dup
default['foreman-proxy']['dhcp_subnet'] = route['destination'].split('/')[0]
default['foreman-proxy']['dhcp_netmask'] = net['addresses'][ip_addr]['netmask']
# TODO: WARNING if range is empty! Cause this lets 'isc-dhcp' fail to start.
default['foreman-proxy']['dhcp_range'] = []
default['foreman-proxy']['dhcp_broadcast'] = net['addresses'][ip_addr]['broadcast']
default['foreman-proxy']['dhcp_routers'] = [route['src']]
default['foreman-proxy']['dhcp_options'] = ["domain-name \"#{node['foreman']['server_name']}\"",
                                            "domain-name-servers #{ip_addr}, 8.8.8.8"]

# global DHCP server config
default['dhcp']['parameters']['omapi-port'] = '7911'
default['dhcp']['parameters']['next-server'] = (node['foreman-proxy']['ip']).to_s

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
# FIXME: Add exception handling for no syslinux files source at all.
# https://theforeman.org/manuals/1.14/index.html#4.3.9TFTP
if platform_family?('debian')
  default['foreman-proxy']['tftp_syslinux_filenames'] = ['/usr/lib/syslinux/pxelinux.0',
                                                         '/usr/lib/syslinux/memdisk',
                                                         '/usr/lib/syslinux/chain.c32',
                                                         '/usr/lib/syslinux/menu.c32']
  # '/usr/lib/syslinux/modules/bios/ldlinux.c32',
  # '/usr/lib/syslinux/modules/bios/libutil.c32']
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
default['foreman-proxy']['oauth_effective_user'] = node['foreman']['admin']['username']
default['foreman-proxy']['oauth_consumer_key'] = cache_data('oauth_consumer_key', random_password)
default['foreman-proxy']['oauth_consumer_secret'] = cache_data('oauth_consumer_secret', random_password)

# Templates options
default['foreman-proxy']['templates'] = false
default['foreman-proxy']['templates_listen_on'] = 'https'

# Chef
default['foreman-proxy']['chef'] = true
default['foreman-proxy']['chef_authenticate_nodes'] = true
default['foreman-proxy']['chef_server_url'] = 'https://chef.example.net'
default['foreman-proxy']['chef_smartproxy_clientname'] = 'host.example.net'
default['foreman-proxy']['chef_smartproxy_privatekey'] = '/etc/chef/client.pem'
default['foreman-proxy']['chef_ssl_verify'] = true
default['foreman-proxy']['chef_ssl_pem_file'] = '/etc/chef/chef.example.com.pem'
