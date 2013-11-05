include_attribute "foreman"

default['foreman']['source']['repo'] = "https://github.com/theforeman/foreman.git"
default['foreman']['source']['revision'] = node['foreman']['version']

