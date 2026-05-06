# Foreman migration

This cookbook is now a full custom-resource implementation.

## Breaking changes

* `recipes/` was removed. Use `foreman_app`, `foreman_proxy`, `foreman_repo`, and `foreman_plugins` instead of `include_recipe`.
* `attributes/` was removed. Pass settings through resource properties or test cookbook inputs.
* Legacy LWRP/provider files were replaced with unified-mode custom resources.
* The cookbook now targets Debian 12 and Ubuntu 22.04, matching current upstream Debian package guidance.
* `chef_version` was raised to `>= 15.3`.

## Resource mapping

* `foreman::default`, `foreman::install`, `foreman::config`, `foreman::database`, `foreman::service`
  Replaced by `foreman_app`.
* `foreman::proxy`, `foreman::proxy_install`, `foreman::proxy_config`, `foreman::proxy_service`, `foreman::proxy_register`
  Replaced by `foreman_proxy`.
* `foreman::repo`
  Replaced by `foreman_repo`.
* `foreman::plugins`
  Replaced by `foreman_plugins`.
* `foreman_rake`, `foreman_smartproxy`, `foreman_proxy_settings_file`
  Retained as custom resources with modern implementations.

## Test cookbook examples

* App usage lives in `test/cookbooks/test/recipes/default.rb`.
* Proxy usage lives in `test/cookbooks/test/recipes/proxy.rb`.
