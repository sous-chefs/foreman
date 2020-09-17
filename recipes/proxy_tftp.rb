# -*- coding: utf-8 -*-
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
  remote_file node['foreman-proxy']['tftp_root'] + '/' + File.basename(file) do
    source lazy { 'file://' + file.to_s }
    owner 'foreman-proxy'
    group 'foreman-proxy'
  end
end

# Argh. This is not working. Archive is not extracted.
# TODO: Add a issue/bug report upstream!
# rubocop:disable Layout/LineLength
# poise_archive 'http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar' do
#  destination '/var/lib/tftpboot/boot'
#  keep_existing false
#  action :unpack
# end

# FIXME: Don't call 'wget' via 'execute'. Use a built-in or provider for that.
# TODO: Add Guard.
execute 'Download and extract Discovery Image' do
  command 'wget -qO- \'http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar\' | tar -x -C /var/lib/tftpboot/boot/'
end

# TODO: Add Guard.
execute 'Correct ownership of extracted Discovery Image' do
  command 'chown -R foreman-proxy:foreman-proxy /var/lib/tftpboot/boot/'
end
