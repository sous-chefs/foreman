directory node['foreman']['config_path']

template ::File.join(node['foreman']['config_path'], 'settings.yaml') do
  source 'settings_foreman.yaml.erb'
end
template ::File.join(node['foreman']['config_path'], 'database.yml')

template ::File.join(node['foreman-proxy']['config_path'], 'settings.yml') do
  source 'settings_foreman-proxy.yml.erb'
end

template '/etc/default/foreman' do
  source 'foreman.default.erb'
end
