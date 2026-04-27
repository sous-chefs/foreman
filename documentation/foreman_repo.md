# foreman_repo

Configures Foreman APT repositories.

## Actions

* `:create` configures the Foreman and Foreman plugin repositories.

## Properties

* `update_cache` - Whether to update APT metadata before configuring repositories. Defaults to `true`.
* `use_repo` - Shared repository toggle. Defaults to `true`.
* `repo_uri` - Foreman repository URI. Defaults to `http://deb.theforeman.org/`.
* `repo_key` - Foreman repository signing key URL.
* `repo_release` - Foreman release. Defaults to `3.18`.
* `repo_distribution` - APT distribution. Defaults to the platform codename.

## Example

```ruby
foreman_repo 'foreman' do
  repo_release '3.18'
end
```
