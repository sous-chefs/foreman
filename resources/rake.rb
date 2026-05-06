# frozen_string_literal: true

provides :foreman_rake
unified_mode true

property :rake_task, String, name_property: true
property :path, String, default: '/usr/share/foreman'
property :environment, Hash, default: {}
property :timeout, Integer

action :run do
  execute "foreman-rake-#{new_resource.rake_task}" do
    command "/usr/sbin/foreman-rake #{new_resource.rake_task}"
    environment({ 'HOME' => new_resource.path }.merge(new_resource.environment.compact))
    timeout new_resource.timeout if new_resource.timeout
  end
end
