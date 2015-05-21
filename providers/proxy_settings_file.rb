#
# Cookbook Name:: foreman
# Provider:: rake
#
require 'shellwords'

action :enable do
  listen_on = case new_resource.listen_on
                when 'both'
                true
                when 'https'
                'https'
                when 'http'
                'http'
                else
                false
              end
  edit_file(listen_on)
end

action :disable do
  edit_file(false)
end

def edit_file(module_enabled)
  path = new_resource.path.nil? ? "/etc/foreman-proxy/settings.d/#{new_resource.module}.yml" : new_resource.path
  template_path = new_resource.template_path.nil? ? "proxy/#{new_resource.module}.yml.erb" : new_resource.template_path

  template path do
    source template_path
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    cookbook new_resource.cookbook unless new_resource.cookbook.nil?
    variables module_enabled: module_enabled
  end

  new_resource.updated_by_last_action(true)
end
