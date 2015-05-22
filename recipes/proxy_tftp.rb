include_recipe 'tftp'

node['foreman-proxy']['tftp_dirs'].each do |dir|
  directory ::File.join(node['foreman-proxy']['tftp_root'], dir) do
    mode 0755
  end
end

# rubocop:disable Metrics/LineLength
["syslinux-#{node['foreman-proxy']['syslinux']['version']}/bios/core/pxelinux.0",
 "syslinux-#{node['foreman-proxy']['syslinux']['version']}/bios/com32/menu/menu.c32",
 "syslinux-#{node['foreman-proxy']['syslinux']['version']}/bios/com32/chain/chain.c32"
].each do |file|
  ark ::File.basename(file) do
    url node['foreman-proxy']['syslinux']['url']
    path node['tftp']['directory']
    creates file
    action :cherry_pick
  end
end
