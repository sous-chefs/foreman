# foreman_proxy_settings_file

Renders a Smart Proxy module settings file.

## Actions

* `:enable` renders the module file with the configured listener.
* `:disable` renders the module file with the module disabled.

## Properties

* `module_name` - Module name. This is the name property.
* `listen_on` - Listener value. One of `both`, `https`, or `http`. Defaults to `https`.
* `config` - Module-specific settings hash.
* `cookbook` - Template cookbook. Defaults to `foreman`.
* `path` - Output path. Defaults to `/etc/foreman-proxy/settings.d/<module_name>.yml`.
* `owner` - File owner. Defaults to `root`.
* `group` - File group. Defaults to `foreman-proxy`.
* `mode` - File mode. Defaults to `0640`.
* `template_path` - Template path. Defaults to `proxy/<module_name>.yml.erb`.

## Example

```ruby
foreman_proxy_settings_file 'dns' do
  listen_on 'https'
  config(
    provider: 'nsupdate',
    server: '127.0.0.1'
  )
end
```
