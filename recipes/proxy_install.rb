include_recipe 'foreman::repo' if node['foreman-proxy']['use_repo']
package 'foreman-proxy' do
  version node['foreman-proxy']['version'] unless node['foreman-proxy']['version'] == 'stable'
end

package node['foreman-proxy']['api_package'] if node['foreman-proxy']['register']

if node['foreman-proxy']['bmc_default_provider'] != 'shell' && node['foreman-proxy']['bmc']
  package node['foreman-proxy']['bmc_default_provider']
end
