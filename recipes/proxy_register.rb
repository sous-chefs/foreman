# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: proxy_register
#
foreman_smartproxy node['foreman-proxy']['registered_name'] do
  base_url node['foreman-proxy']['foreman_base_url']
  consumer_key node['foreman-proxy']['oauth_consumer_key']
  consumer_secret node['foreman-proxy']['oauth_consumer_secret']
  effective_user node['foreman-proxy']['oauth_effective_user']
  url node['foreman-proxy']['registered_proxy_url']
  only_if { node['foreman-proxy']['register'] }
  action :create
end
