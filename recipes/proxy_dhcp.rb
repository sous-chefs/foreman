#
# Cookbook:: foreman
# Recipe:: proxy_dhcp
#
include_recipe 'dhcp::server'

dhcp_subnet 'foreman' do
  subnet node['foreman-proxy']['dhcp_subnet']
  pool do
    range node['foreman-proxy']['dhcp_range']
  end
  netmask node['foreman-proxy']['dhcp_netmask']
  broadcast node['foreman-proxy']['dhcp_broadcast']
  next_server node['foreman-proxy']['ip']
  routers node['foreman-proxy']['dhcp_routers']
  options node['foreman-proxy']['dhcp_options']
end
