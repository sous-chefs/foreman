# frozen_string_literal: true

proxy_config = node.dig('foreman_test', 'proxy') || {}

foreman_proxy 'default' do
  server_name proxy_config['server_name'] || 'foreman.example'
  register proxy_config.fetch('register', false)
  ssl(proxy_config['ssl'] || {})
  dns(proxy_config['dns'] || {})
  dhcp(proxy_config['dhcp'] || {})
  tftp(proxy_config['tftp'] || {})
  bmc(proxy_config['bmc'] || {})
  chef_module(proxy_config['chef_module'] || {})
  templates_module(proxy_config['templates_module'] || {})
end
