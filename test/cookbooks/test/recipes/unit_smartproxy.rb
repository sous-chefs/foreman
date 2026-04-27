# frozen_string_literal: true

foreman_smartproxy 'proxy.example' do
  base_url 'https://foreman.example'
  effective_user 'admin'
  consumer_key 'key'
  consumer_secret 'secret'
  url 'https://proxy.example:8443'
end
