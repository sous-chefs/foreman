#
# Cookbook Name:: foreman
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "foreman::repo" if node['foreman']['use_repo']

%w(foreman foreman-sqlite3 foreman-libvirt foreman-proxy).each do |pack|
  package pack
end

include_recipe "foreman::config"

node.default['foreman']['user'] = "foreman"
node.default['foreman']['config_path'] = "/etc/foreman"

#execute "foreman dbmigrate" do
#  command "/bin/bash -c /usr/share/foreman/extras/dbmigrate"
#  user node['foreman']['user']
#end
