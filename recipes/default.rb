#
# Cookbook:: foreman
# Recipe:: default
#
ohai 'reload' do
  action :reload
end

include_recipe 'foreman::install'
include_recipe 'foreman::config'
include_recipe 'foreman::database'
include_recipe 'foreman::plugins'
include_recipe 'foreman::service'
