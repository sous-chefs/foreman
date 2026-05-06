# foreman_app

Installs and configures the Foreman application service.

## Actions

* `:install` installs Foreman, writes application configuration, optionally manages the database, and starts the `foreman` and Apache services.

## Properties

* `server_name` - Foreman server FQDN. Defaults to `foreman.example`.
* `manage_hostname` - Whether to set the system hostname. Defaults to `true`.
* `version` - Optional package version.
* `path` - Foreman application path. Defaults to `/usr/share/foreman`.
* `config_path` - Foreman config path. Defaults to `/etc/foreman`.
* `environment` - Rails environment. Defaults to `production`.
* `user` - Foreman user. Defaults to `foreman`.
* `group` - Foreman group. Defaults to `foreman`.
* `group_users` - Extra group members.
* `manage_database` - Whether to prepare and migrate the database. Defaults to `true`.
* `database` - Database configuration hash.
* `admin` - Initial admin seed configuration hash.
* `initial_organization` - Optional seed organization.
* `initial_location` - Optional seed location.
* `passenger` - Passenger configuration hash.
* `ssl_enabled` - Whether to configure SSL. Defaults to `true`.
* `ssl` - SSL path override hash.
* `settings` - Foreman settings hash.
* `ssl_data_bag_name` - SSL data bag name. Defaults to `foreman`.
* `ssl_data_bag_item` - SSL data bag item. Defaults to the Chef environment.
* `use_repo` - Whether to configure Foreman APT repositories. Defaults to `true`.
* `repo_uri` - Foreman repository URI. Defaults to `http://deb.theforeman.org/`.
* `repo_key` - Foreman repository signing key URL.
* `repo_release` - Foreman release. Defaults to `3.18`.
* `repo_distribution` - APT distribution. Defaults to the platform codename.

## Example

```ruby
foreman_app 'default' do
  server_name 'foreman.example'
  manage_hostname false
  manage_database false
  database(
    adapter: 'postgresql',
    username: 'foreman',
    password: 'super-secret'
  )
end
```
