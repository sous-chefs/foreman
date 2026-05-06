# foreman_rake

Runs a Foreman rake task.

## Actions

* `:run` executes the requested task with `foreman-rake`.

## Properties

* `rake_task` - Rake task name. This is the name property.
* `path` - Foreman application path used as `HOME`. Defaults to `/usr/share/foreman`.
* `environment` - Extra environment variables.
* `timeout` - Optional command timeout.

## Example

```ruby
foreman_rake 'db:migrate' do
  path '/usr/share/foreman'
end
```
