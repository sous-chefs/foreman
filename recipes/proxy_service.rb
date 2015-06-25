# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: proxy_service
#
service 'foreman-proxy' do
  action :restart
end
