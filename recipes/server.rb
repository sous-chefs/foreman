include_recipe "uwsgi::install_gem"

uwsgi "foreman" do
  parameters(
    "socket" => "127.0.0.1:3031",
    "processes" => "4",
    "master" => "true",
    "chdir" => node['foreman']['current_path'],
    "rbrequire" => "rubygems",
    "rbrequire" => "bundler/setup",
    "rack" => "config.ru"
  )
end
