include_attribute 'dhcp'

default['dhcp']['interfaces'] = ['eth0']
default['dhcp']['options']['domain-name'] = '"example"'
default['dhcp']['options']['domain-search'] = '"example"'
