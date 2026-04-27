# frozen_string_literal: true

provides :foreman_proxy_settings_file
unified_mode true

property :module_name, String, name_property: true
property :listen_on, String, equal_to: %w(both https http), default: 'https'
property :config, Hash, default: {}
property :cookbook, String, default: 'foreman'
property :path, String, default: lazy { "/etc/foreman-proxy/settings.d/#{module_name}.yml" }
property :owner, String, default: 'root'
property :group, String, default: 'foreman-proxy'
property :mode, String, default: '0640'
property :template_path, String, default: lazy { "proxy/#{module_name}.yml.erb" }

action :enable do
  render_settings_file(normalized_listener)
end

action :disable do
  render_settings_file(false)
end

action_class do
  def normalized_listener
    case new_resource.listen_on
    when 'both'
      true
    when 'https', 'http'
      new_resource.listen_on
    else
      false
    end
  end

  def render_settings_file(module_enabled)
    template new_resource.path do
      source new_resource.template_path
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode
      variables(
        config: new_resource.config,
        module_enabled: module_enabled,
        module_name: new_resource.module_name
      )
    end
  end
end
