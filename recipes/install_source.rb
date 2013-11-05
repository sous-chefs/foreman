include_recipe "git"

deploy_revision "foreman" do
  deploy_to node['foreman']['path']
  repository node['foreman']['source']['repo']
  revision node['foreman']['source']['revision']
  symlinks({
    "database.yml" => "config/database.yml",
    "settings.yaml" => "config/settings.yaml"})
end

node.default['foreman']['current_path'] = ::File.join(node['foreman']['path'], "current")
node.default['foreman']['config_path'] = ::File.join(node['foreman']['path'], "shared")

#gem install bundler

#application "foreman" do
#  path node['foreman']['path']
#  repository node['foreman']['source']['repo']
#  revision node['foreman']['source']['revision']
#  symlink_before_migrate({ "settings.yaml" => "config/settings.yaml"})
#  symlinks({ "settings.yaml" => "config/settings.yaml"})
#
#  rails do
#    gems ['bundler']
#    use_omnibus_ruby false
#    bundler_without_groups ['mysql', 'mysql2', 'pg']
#  end
#end

include_recipe "foreman::server"
