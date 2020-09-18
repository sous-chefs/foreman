#
# Cookbook:: foreman
# Recipe:: plugins
#

node['foreman']['plugins'].each do |pack|
  package pack
end
