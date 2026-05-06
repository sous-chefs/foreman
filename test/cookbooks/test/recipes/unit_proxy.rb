# frozen_string_literal: true

foreman_proxy 'default' do
  register false
  dhcp(interface: 'eth0', managed: false, range: '10.0.0.10 10.0.0.20')
  dns(interface: 'eth0', managed: false)
end
