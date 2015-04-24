include_recipe "foreman::install_#{node['foreman']['install_method']}"

include_recipe 'passenger_apache2'
