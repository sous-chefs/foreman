#
# Cookbook:: foreman
# Recipe:: proxy_service
#
service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

service 'foreman-proxy' do
  notifies :restart, 'service[apache2]', :immediately
  action :restart
end
