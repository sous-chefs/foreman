# -*- coding: utf-8 -*-
#
# Cookbook:: foreman
# Recipe:: proxy_service
#
service 'foreman-proxy' do
  notifies :restart, 'service[apache2]', :immediately if node.recipe?('apache2')
  action :restart
end
