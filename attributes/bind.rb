include_attribute 'bind'

default['bind']['acl-role'] = 'external-acl'
default['bind']['zonetype'] = 'master'
default['bind']['masters'] = %w[127.0.0.1]
default['bind']['ipv6_listen'] = true
default['bind']['options'] = [
  'check-names slave ignore;',
  'multi-master yes;',
  'provide-ixfr yes;',
  'request-ixfr yes;',
  'empty-zones-enable no;'
]
