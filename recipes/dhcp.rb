include_recipe 'dhcp::server'

dhcp_subnet 'foreman' do
  subnet '192.168.55.0'
  range '192.168.55.100 192.168.55.200'
  netmask '255.255.255.0'
  broadcast '192.168.1.255'
  routers ['192.168.55.1']
  options [
    "option domain-name \"#{node['foreman']['domain']}\"",
    'option domain-name-servers 192.168.55.1, 8.8.8.8'
  ]
end
