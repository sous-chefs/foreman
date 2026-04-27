# frozen_string_literal: true

provides :foreman_plugins
unified_mode true

use '_partial/_repository'

property :packages, [String, Array], coerce: proc { |value| Array(value) }, default: []

action :install do
  foreman_repo 'foreman-plugins-repository' do
    repo_uri new_resource.repo_uri
    repo_key new_resource.repo_key
    repo_release new_resource.repo_release
    repo_distribution new_resource.repo_distribution
    only_if { new_resource.use_repo }
  end

  new_resource.packages.each do |plugin_package|
    package plugin_package
  end
end
