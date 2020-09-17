# -*- coding: utf-8 -*-
#
# Cookbook:: foreman
# Provider:: smartproxy
#

action :create do
  if id.nil?
    api.call(:create,
             smart_proxy: {
               'name' => new_resource.smartproxy_name,
               'url' => new_resource.url,
             })
  else
    api.call(:update, id: id, smart_proxy: { url: new_resource.url })
  end

  new_resource.updated_by_last_action(true)
end

action :remove do
  api.call(:destroy, id: id)
  @proxy = nil
  new_resource.updated_by_last_action(true)
end

def api
  chef_gem 'apipie-bindings'
  require 'apipie-bindings'

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
    apidoc_cache_base_dir: ::File.join(Chef::Config[:file_cache_path],
                                       'apipie_bindings'),
  }

  options = { verify_ssl: ::OpenSSL::SSL::VERIFY_NONE }
  @api ||= ApipieBindings::API
           .new(settings, options)
           .resource(:smart_proxies)
end

def proxy
  if @proxy
    @proxy
  else
    @proxy = api.call(:index,
                      # rubocop:disable Layout/LineLength
                      search: "name=#{new_resource.smartproxy_name}")['results'][0]
  end
end

def id
  proxy ? proxy['id'] : nil
end
