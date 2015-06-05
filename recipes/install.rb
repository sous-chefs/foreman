# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: install
#
include_recipe 'foreman::repo' if node['foreman']['use_repo']

package 'foreman' do
  version node['foreman']['version'] unless
    node['foreman']['version'] == 'stable'
end

node['foreman']['compute_plugins'].each do |pack|
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
# @TODO remove when apache2 will works fine
execute 'remove-other-vhost' do
  command 'a2disconf other-vhosts-access-log && sleep 2'
end

package node['foreman']['passenger']['package'] do
  action :install
  only_if { node['foreman']['passenger']['install'] }
end
