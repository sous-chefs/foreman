#
# Cookbook:: foreman
# Recipe:: proxy_tftp
#
include_recipe 'tftp'

directory node['foreman-proxy']['tftp_root'] do
  owner 'foreman-proxy'
  group 'foreman-proxy'
end

node['foreman-proxy']['tftp_dirs'].each do |dir|
  directory ::File.join(node['foreman-proxy']['tftp_root'], dir) do
    mode '775'
    owner 'foreman-proxy'
    group 'foreman-proxy'
  end
end

package 'syslinux-common'

node['foreman-proxy']['tftp_syslinux_filenames'].each do |file|
  link node['foreman-proxy']['tftp_root'] + '/' + File.basename(file) do
    to file
    owner 'foreman-proxy'
    group 'foreman-proxy'
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/fdi-image-latest.tar" do
  source 'http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar'
end

archive_file 'Precompiled.zip' do
  path "#{Chef::Config[:file_cache_path]}/fdi-image-latest.tar"
  destination '/var/lib/tftpboot/boot/'
  owner 'foreman-proxy'
  group 'foreman-proxy'
end
