# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: proxy_service
#
service 'foreman-proxy' do
  notifies :restart, 'service[apache2]', :immediately
  action :restart
end
