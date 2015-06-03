#
# Cookbook Name:: foreman
# Resource:: smartproxy
#
actions :create, :remove
default_action :create

attribute :smartproxy_name, kind_of: String, name_attribute: true
attribute :base_url, kind_of: String
attribute :effective_user, kind_of: String
attribute :consumer_key, kind_of: String
attribute :consumer_secret, kind_of: String
attribute :url, required: true, kind_of: String
attribute :timeout, kind_of: [Integer, String], default: 5000
