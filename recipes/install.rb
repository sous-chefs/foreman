#
# Cookbook:: foreman
# Recipe:: install
#
include_recipe 'foreman::repo' if node['foreman']['use_repo']

package 'foreman' do
  version node['foreman']['version']
end

case node['foreman']['db']['adapter']
when 'sqlite'
  pkg = if platform_family?('debian')
          'foreman-sqlite3'
        else
          'foreman-sqlite'
        end
when 'postgresql'
  pkg = 'foreman-postgresql'
when 'mysql'
  pkg = 'foreman-mysql2'
end

package pkg

apache2_install 'default_install'

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

package node['foreman']['passenger']['package'] do
  action :install
  only_if { node['foreman']['passenger']['install'] }
end
