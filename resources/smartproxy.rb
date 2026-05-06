# frozen_string_literal: true

provides :foreman_smartproxy
unified_mode true

property :smartproxy_name, String, name_property: true
property :base_url, String, required: true
property :effective_user, String, required: true
property :consumer_key, String, required: true, sensitive: true
property :consumer_secret, String, required: true, sensitive: true
property :url, String, required: true
property :timeout, [Integer, String], default: 5000

action :create do
  current_proxy = smart_proxy

  if current_proxy.nil?
    converge_by("register smart proxy #{new_resource.smartproxy_name}") do
      smart_proxy_api.call(:create,
                           smart_proxy: {
                             'name' => new_resource.smartproxy_name,
                             'url' => new_resource.url,
                           })
    end
  elsif current_proxy['url'] != new_resource.url
    converge_by("update smart proxy #{new_resource.smartproxy_name}") do
      smart_proxy_api.call(:update,
                           id: current_proxy['id'],
                           smart_proxy: { url: new_resource.url })
    end
  end
end

action :remove do
  current_proxy = smart_proxy
  return if current_proxy.nil?

  converge_by("remove smart proxy #{new_resource.smartproxy_name}") do
    smart_proxy_api.call(:destroy, id: current_proxy['id'])
  end
end

action_class do
  def smart_proxy_api
    chef_gem 'apipie-bindings' do
      compile_time true
    end

    require 'apipie-bindings' unless defined?(ApipieBindings::API)

    settings = {
      uri: new_resource.base_url,
      api_version: 2,
      oauth: {
        consumer_key: new_resource.consumer_key,
        consumer_secret: new_resource.consumer_secret,
      },
      timeout: new_resource.timeout,
      headers: {
        foreman_user: new_resource.effective_user,
      },
      apidoc_cache_base_dir: ::File.join(Chef::Config[:file_cache_path], 'apipie_bindings'),
    }

    options = { verify_ssl: ::OpenSSL::SSL::VERIFY_NONE }
    @smart_proxy_api ||= ApipieBindings::API.new(settings, options).resource(:smart_proxies)
  end

  def smart_proxy
    @smart_proxy ||= smart_proxy_api.call(:index, search: "name=#{new_resource.smartproxy_name}")['results'][0]
  end
end
