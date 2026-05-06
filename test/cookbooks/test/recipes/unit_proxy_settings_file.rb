# frozen_string_literal: true

foreman_proxy_settings_file 'dns' do
  config(provider: 'nsupdate', server: '127.0.0.1', ttl: '86400', keyfile: '/etc/bind/rndc.key')
end
