#
# Cookbook:: foreman
# Recipe:: proxy_install
#
include_recipe 'foreman::repo' if node['foreman']['use_repo']
package 'foreman-proxy' do
  version node['foreman-proxy']['version'] unless
    node['foreman-proxy']['version'] == 'stable'
end

node['foreman-proxy']['plugins'].each do |pack|
  package pack
end

package node['foreman-proxy']['api_package'] if
  node['foreman-proxy']['register']

package node['foreman-proxy']['bmc_default_provider'] do
  only_if do
    node['foreman-proxy']['bmc_default_provider'] != 'shell' &&
      node['foreman-proxy']['bmc']
  end
end
