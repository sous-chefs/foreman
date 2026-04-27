# foreman_smartproxy

Registers or removes a Smart Proxy through the Foreman API.

## Actions

* `:create` registers the Smart Proxy or updates its URL when it already exists.
* `:remove` removes the Smart Proxy registration when present.

## Properties

* `smartproxy_name` - Smart Proxy name. This is the name property.
* `base_url` - Foreman base URL.
* `effective_user` - Foreman API effective user.
* `consumer_key` - OAuth consumer key.
* `consumer_secret` - OAuth consumer secret.
* `url` - Smart Proxy URL to register.
* `timeout` - API timeout. Defaults to `5000`.

## Example

```ruby
foreman_smartproxy 'foreman-proxy.example' do
  base_url 'https://foreman.example'
  effective_user 'admin'
  consumer_key 'consumer-key'
  consumer_secret 'consumer-secret'
  url 'https://foreman-proxy.example:8443'
end
```
