# rubocop:disable Metrics/LineLength

include_attribute 'tftp'
include_attribute 'dhcp'

default['foreman-proxy']['config_path'] = '/etc/foreman-proxy'
default['foreman-proxy']['settings']['daemon'] = true
default['foreman-proxy']['settings']['port'] = 8443
default['foreman-proxy']['settings']['tftp'] = true
default['foreman-proxy']['settings']['tftproot'] = node['tftp']['directory']

default['foreman-proxy']['settings']['dns'] = true

default['foreman-proxy']['settings']['dhcp'] = true
default['foreman-proxy']['settings']['dhcp_vendor'] = 'isc'

default['foreman-proxy']['settings']['dhcp_config'] = node['dhcp']['config_file']
default['foreman-proxy']['settings']['dhcp_leases'] = '/var/lib/dhcp3/dhcpd.leases'

default['foreman-proxy']['settings']['puppetca'] = false

default['foreman-proxy']['settings']['puppet'] = false
