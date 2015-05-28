include_recipe 'dhcp::server'

dhcp_subnet 'foreman' do
  subnet node['foreman-proxy']['dhcp_subnet']
  range node['foreman-proxy']['dhcp_range']
  netmask node['foreman-proxy']['dhcp_netmask']
  broadcast node['foreman-proxy']['dhcp_broadcast']
  routers node['foreman-proxy']['dhcp_routers']
  options node['foreman-proxy']['dhcp_options']
end
