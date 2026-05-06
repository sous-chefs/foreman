# Foreman cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/foreman.svg)](https://supermarket.chef.io/cookbooks/foreman)
[![CI State](https://github.com/sous-chefs/foreman/actions/workflows/ci.yml/badge.svg)](https://github.com/sous-chefs/foreman/actions/workflows/ci.yml)

This cookbook now exposes custom resources for installing and configuring Foreman and Foreman Smart Proxy. The legacy `recipes/` and `attributes/` APIs were removed as part of the migration.

* Migration notes: [migration.md](migration.md)
* Platform and package constraints: [LIMITATIONS.md](LIMITATIONS.md)

## Resources

* `foreman_app`
  Installs Foreman, renders application configuration, optionally prepares the database, and manages the `foreman` service.
* `foreman_proxy`
  Installs Smart Proxy, renders `settings.yml` and module fragments, optionally configures DNS/DHCP/TFTP helpers, and manages the `foreman-proxy` service.
* `foreman_repo`
  Configures the official Foreman APT repositories.
* `foreman_plugins`
  Installs Foreman or Smart Proxy plugin packages.
* `foreman_rake`
  Runs `foreman-rake` tasks.
* `foreman_smartproxy`
  Registers or removes a Smart Proxy through the Foreman API.
* `foreman_proxy_settings_file`
  Renders a module file under `/etc/foreman-proxy/settings.d/`.

## Supported platforms

* Debian 12
* Ubuntu 22.04

These limits are based on the current upstream package documentation summarized in [LIMITATIONS.md](LIMITATIONS.md).

## Usage

### Foreman server

```ruby
foreman_app 'default' do
  server_name 'foreman.example'
  database(
    adapter: 'postgresql',
    host: '127.0.0.1',
    username: 'foreman',
    password: 'super-secret'
  )
end

foreman_plugins 'server-plugins' do
  packages %w[foreman-libvirt ruby-foreman-chef]
end
```

### Foreman Smart Proxy

```ruby
foreman_proxy 'default' do
  server_name 'foreman.example'
  register false
  dns(
    enabled: true,
    managed: true,
    interface: 'eth0'
  )
  dhcp(
    enabled: true,
    managed: true,
    interface: 'eth0',
    range: '10.0.0.10 10.0.0.20'
  )
  tftp(
    enabled: true
  )
end
```

## Testing

* `cookstyle`
* `chef exec rspec --format documentation`
* `yamllint .`
* `markdownlint-cli2 "**/*.md"`
* `KITCHEN_LOCAL_YAML=kitchen.dokken.yml chef exec kitchen test default-ubuntu-2204 --destroy=always`
* `KITCHEN_LOCAL_YAML=kitchen.dokken.yml chef exec kitchen test proxy-debian-12 --destroy=always`
