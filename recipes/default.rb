#
# Cookbook Name:: foreman
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "hostname"
include_recipe "foreman::install_#{node['foreman']['install_method']}" if node['foreman']['install_method']
include_recipe "foreman::tftp"
include_recipe "foreman::dns"
include_recipe "foreman::dhcp"
