# foreman_proxy

Installs and configures Foreman Smart Proxy.

## Actions

* `:install` installs Smart Proxy, writes global and module settings, optionally manages DNS/DHCP/TFTP helpers, starts the service, and optionally registers the proxy with Foreman.

## Properties

* `version` - Optional package version.
* `config_path` - Smart Proxy config path. Defaults to `/etc/foreman-proxy`.
* `daemon` - Whether Smart Proxy should run as a daemon. Defaults to `true`.
* `user` - Smart Proxy user. Defaults to `foreman-proxy`.
* `group` - Smart Proxy group. Defaults to `foreman-proxy`.
* `group_users` - Extra group members.
* `plugins` - Smart Proxy plugin packages. Defaults to an empty array because package names vary by release.
* `register` - Whether to register with Foreman. Defaults to `true`.
* `api_package` - API client package used for registration. Defaults to `ruby-apipie-bindings`.
* `service_name` - Service name. Defaults to `foreman-proxy`.
* `server_name` - Foreman server FQDN. Defaults to `foreman.example`.
* `http_enabled` - Whether HTTP is enabled. Defaults to `false`.
* `http_port` - HTTP port. Defaults to `8000`.
* `ssl_enabled` - Whether HTTPS is enabled. Defaults to `true`.
* `https_port` - HTTPS port. Defaults to `8443`.
* `trusted_hosts` - Trusted Foreman hosts.
* `foreman_base_url` - Foreman base URL override.
* `registered_name` - Smart Proxy name override.
* `registered_proxy_url` - Smart Proxy URL override.
* `oauth_effective_user` - Foreman API effective user. Defaults to `admin`.
* `oauth_consumer_key` - Foreman OAuth consumer key.
* `oauth_consumer_secret` - Foreman OAuth consumer secret.
* `virsh_network` - Libvirt network name. Defaults to `default`.
* `log_file` - Smart Proxy log path.
* `log_level` - Smart Proxy log level. Defaults to `ERROR`.
* `ssl`, `dns`, `dhcp`, `tftp`, `bmc`, `chef_module`, `puppet`, `puppetca`, `realm`, `templates_module` - Module configuration hashes.
* `ssl_data_bag_name` - SSL data bag name. Defaults to `foreman-proxy`.
* `ssl_data_bag_item` - SSL data bag item. Defaults to the Chef environment.
* `use_repo` - Whether to configure Foreman APT repositories. Defaults to `true`.
* `repo_uri` - Foreman repository URI. Defaults to `http://deb.theforeman.org/`.
* `repo_key` - Foreman repository signing key URL.
* `repo_release` - Foreman release. Defaults to `3.18`.
* `repo_distribution` - APT distribution. Defaults to the platform codename.

## Example

```ruby
foreman_proxy 'default' do
  server_name 'foreman.example'
  register false
  dns(enabled: true, managed: true, interface: 'eth0')
  dhcp(enabled: true, managed: true, interface: 'eth0', range: '10.0.0.10 10.0.0.20')
  tftp(enabled: true)
end
```
