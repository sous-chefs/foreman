# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Provider:: rake
#
require 'shellwords'

action :run do
  rake_command = "/usr/sbin/foreman-rake #{new_resource.rake_task}"
  unless new_resource.environment.nil?
    rake_command += ' '
    rake_command += new_resource.environment
                    .reject { |_k, v| v.nil? }.map do |k, v|
                      "#{k}=#{Shellwords.escape(v)}"
                    end.join(' ')
  end

  execute "foreman-rake-#{new_resource.rake_task}" do
    command rake_command
    environment({ 'HOME' => node['foreman']['path'] }
                  .merge(new_resource.environment))
    timeout new_resource.timeout unless new_resource.timeout.nil?
  end

  new_resource.updated_by_last_action(true)
end
