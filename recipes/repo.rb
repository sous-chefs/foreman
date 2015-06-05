# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: repo
#
include_recipe 'apt'

apt_repository 'foreman' do
  uri node['foreman']['repo']['uri']
  distribution node['lsb']['codename']
  components node['foreman']['repo']['components']
  key node['foreman']['repo']['key']
end
