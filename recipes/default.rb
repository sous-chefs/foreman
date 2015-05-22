#
# Cookbook Name:: foreman
# Recipe:: default
#

include_recipe 'hostname'
include_recipe 'foreman::install'
include_recipe 'foreman::config'
include_recipe 'foreman::database'
include_recipe 'foreman::service'
