#
# Cookbook:: foreman
# Recipe:: install
#
include_recipe 'foreman::repo' if node['foreman']['use_repo']

# Ubuntu Trusty (14.04) comes with Ruby 1.9.1 as default Ruby version.
# Foreman 1.14 requires Ruby >= 2.0.0.
package 'ruby2.0'

# Setting 'ruby2.0' as alternative Ruby version is broken in Trusty.
# https://bugs.launchpad.net/ubuntu/+source/ruby2.0/+bug/1310292
# So we have to adjust the symlinks on our own.
# TODO Move these commands into Chef ressources.
bash 'Handle broken Ruby 2.0 in Trusty.' do
  code <<-EOH
  rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb
  ln -s /usr/bin/ruby2.0 /usr/bin/ruby
  ln -s /usr/bin/gem2.0 /usr/bin/gem
  ln -s /usr/bin/irb2.0 /usr/bin/irb
  ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc
  ln -s /usr/bin/erb2.0 /usr/bin/erb
  EOH
  only_if 'ruby -v | grep -q ruby\ 1.9'
end

package 'foreman' do
  version node['foreman']['version'] unless
    node['foreman']['version'] == 'stable'
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

include_recipe 'apache2'
# @TODO remove when apache2 will works fine
execute 'remove-other-vhost' do
  command 'a2disconf other-vhosts-access-log && sleep 2'
end

package node['foreman']['passenger']['package'] do
  action :install
  only_if { node['foreman']['passenger']['install'] }
end
