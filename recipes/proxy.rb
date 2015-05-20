include_recipe 'foreman::repo' if node['foreman-proxy']['use_repo']

package 'foreman-proxy'
package node['foreman-proxy']['api_package'] if node['foreman-proxy']['register']

if node['foreman-proxy']['bmc_default_provider'] != 'shell' && node['foreman-proxy']['bmc']
  package node['foreman-proxy']['bmc_default_provider']
end

include_recipe 'foreman::tftp' if node['foreman-proxy']['tftp']

template ::File.join(node['foreman-proxy']['config_path'], 'settings.yml') do
  group node['foreman']['group']
  source 'settings_foreman-proxy.yml.erb'
end
