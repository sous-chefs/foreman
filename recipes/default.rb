# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: default
#
include_recipe 'hostname'
ohai 'reload' do
  action :reload
end

include_recipe 'foreman::install'
include_recipe 'foreman::config'
include_recipe 'foreman::database'
include_recipe 'foreman::service'
