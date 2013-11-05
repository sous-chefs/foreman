node.default!['bind']['zones']['attribute'] = [ node['foreman']['domain'] ]

include_recipe "bind"
