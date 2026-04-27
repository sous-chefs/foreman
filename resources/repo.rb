# frozen_string_literal: true

provides :foreman_repo
unified_mode true

use '_partial/_repository'

property :update_cache, [true, false], default: true

action_class do
  include ForemanCookbook::Helpers
end

action :create do
  apt_update 'foreman-package-cache' if new_resource.update_cache

  apt_repository 'foreman' do
    uri new_resource.repo_uri
    distribution new_resource.repo_distribution
    components [new_resource.repo_release]
    key new_resource.repo_key
  end

  apt_repository 'foreman_plugins' do
    uri new_resource.repo_uri
    distribution 'plugins'
    components [new_resource.repo_release]
    key new_resource.repo_key
  end
end
