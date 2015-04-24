include_recipe 'tftp'

['pxelinux.cfg', 'boot'].each do |dir|
  directory ::File.join(node['tftp']['directory'], dir) do
    mode 0755
  end
end

["syslinux-#{node['foreman']['syslinux']['version']}/bios/core/pxelinux.0",
 "syslinux-#{node['foreman']['syslinux']['version']}/bios/com32/menu/menu.c32",
 "syslinux-#{node['foreman']['syslinux']['version']}/bios/com32/chain/chain.c32"
].each do |file|
  ark ::File.basename(file) do
    url node['foreman']['syslinux']['url']
    path node['tftp']['directory']
    creates file
    strip_leading_dir false
    action :cherry_pick
  end
end
