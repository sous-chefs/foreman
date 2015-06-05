# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Provider:: proxy_settings_file
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

  new_resource.updated_by_last_action(true)
end

action :disable do
  edit_file(false)

  new_resource.updated_by_last_action(true)
end

def edit_file(module_enabled)
  path = if new_resource.path.nil?
           "/etc/foreman-proxy/settings.d/#{new_resource.module}.yml"
         else
           new_resource.path
         end
  template_path = if new_resource.template_path.nil?
                    "proxy/#{new_resource.module}.yml.erb"
                  else
                    new_resource.template_path
                  end

  template path do
    source template_path
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    cookbook new_resource.cookbook unless new_resource.cookbook.nil?
    variables module_enabled: module_enabled
  end
end
