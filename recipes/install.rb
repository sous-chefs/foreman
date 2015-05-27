include_recipe 'foreman::repo' if node['foreman']['use_repo']

package 'foreman' do
  version node['foreman']['version'] unless
    node['foreman']['version'] == 'stable'
end

node['foreman']['plugins'].each do |pack|
  package pack
end

case node['foreman']['db']['adapter']
when 'sqlite'
  if node['platform_family'] == 'debian'
    pkg = 'foreman-sqlite3'
  else
    pkg = 'foreman-sqlite'
  end
when 'postgresql'
  pkg = 'foreman-postgresql'
when 'mysql'
  pkg = 'foreman-mysql2'
end

package pkg

include_recipe 'apache2'

package node['foreman']['passenger']['package'] do
  action :install
  only_if { node['foreman']['passenger']['install'] }
end
