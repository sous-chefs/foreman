default['bind']['acl-role'] = 'external-acl'
default['bind']['masters'] = %w()
default['bind']['ipv6_listen'] = true
default['bind']['zonetype'] = 'master'
default['bind']['options'] = [
  'recursion no;',
  'allow-query { any; };',
  'allow-transfer { any; };',
  'allow-notify { any; };',
  'listen-on-v6 { any; };'
]
