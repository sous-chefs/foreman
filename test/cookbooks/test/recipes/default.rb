# frozen_string_literal: true

foreman_app 'default' do
  server_name node.dig('foreman_test', 'server_name') || 'foreman.example'
  manage_hostname node.dig('foreman_test', 'manage_hostname').nil? ? false : node.dig('foreman_test', 'manage_hostname')
  manage_database node.dig('foreman_test', 'manage_database').nil? ? false : node.dig('foreman_test', 'manage_database')
  database(node.dig('foreman_test', 'database') || {})
  admin(node.dig('foreman_test', 'admin') || {})
  settings(node.dig('foreman_test', 'settings') || {})
end

foreman_plugins 'default' do
  packages(node.dig('foreman_test', 'plugins') || %w(foreman-libvirt ruby-foreman-ansible))
end
