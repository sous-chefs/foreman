node.override['bind']['zones']['attribute'] = [node['foreman']['domain']]

hostsfile_entry '127.0.0.1' do
  hostname node['foreman']['domain']
  action :append
end

include_recipe 'bind'
