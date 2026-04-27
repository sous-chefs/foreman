# foreman_plugins

Installs Foreman plugin packages.

## Actions

* `:install` optionally configures the Foreman plugin repository and installs the requested packages.

## Properties

* `packages` - String or array of package names to install. Defaults to an empty array.
* `use_repo` - Whether to configure Foreman APT repositories. Defaults to `true`.
* `repo_uri` - Foreman repository URI. Defaults to `http://deb.theforeman.org/`.
* `repo_key` - Foreman repository signing key URL.
* `repo_release` - Foreman release. Defaults to `3.18`.
* `repo_distribution` - APT distribution. Defaults to the platform codename.

## Example

```ruby
foreman_plugins 'server-plugins' do
  packages %w[foreman-libvirt ruby-foreman-chef]
end
```
