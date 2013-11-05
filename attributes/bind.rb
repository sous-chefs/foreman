
#default!['bind']['zones']['attribute'] = [node['foreman']['domain']]
default!['bind']['zonetype'] = 'master'
default!['bind']['options'] = ['allow-update { any; };']
