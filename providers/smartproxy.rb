# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Provider:: smartproxy
#

action :create do
  api.call(:create,
           smart_proxy: {
             'name' => new_resource.smartproxy_name,
             'url' => new_resource.url
           })
  new_resource.updated_by_last_action(true)
end

action :destroy do
  api.call(:destroy, id: id)
  @proxy = nil
  new_resource.updated_by_last_action(true)
end

def api
  chef_gem 'apipie-bindings'
  require 'apipie-bindings'

  @api ||= ApipieBindings::API
           .new(uri: new_resource.base_url,
                api_version: 2,
                oauth: {
                  consumer_key: new_resource.consumer_key,
                  consumer_secret: new_resource.consumer_secret
                },
                timeout: new_resource.timeout,
                headers: {
                  foreman_user: new_resource.effective_user
                }).resource(:smart_proxies)
end

def proxy
  if @proxy
    @proxy
  else
    @proxy = api.call(:index,
                      search: "name=#{new_resource.smartproxy_name}"
                     )['results'][0]
  end
end

def id
  proxy ? proxy['id'] : nil
end
