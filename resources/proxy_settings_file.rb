#
# Cookbook:: foreman
# Resource:: proxy_settings_file
#
actions :enable, :disable
default_action :enable

attribute :module, kind_of: String, name_attribute: true
attribute :listen_on, kind_of: String, default: 'https'
attribute :cookbook, kind_of: String, default: nil
attribute :path, kind_of: String, default: nil
attribute :owner, kind_of: String, default: 'root'
attribute :group, kind_of: String, default: node['foreman-proxy']['group']
attribute :mode, default: '0640'
attribute :template_path, kind_of: String, default: nil
