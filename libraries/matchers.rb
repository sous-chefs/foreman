if defined?(ChefSpec)
  def run_foreman_rake(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:foreman_rake, :run, resource_name)
  end

  def enable_foreman_proxy_settings_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:foreman_proxy_settings_file, :enable, resource_name)
  end

  def disable_foreman_proxy_settings_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:foreman_proxy_settings_file, :disable, resource_name)
  end

  def create_foreman_smartproxy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:foreman_smartproxy, :create, resource_name)
  end

  def remove_foreman_smartproxy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:foreman_smartproxy, :remove, resource_name)
  end

  # Missing matchers in dependencies
  def cherry_pick_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ark, :cherry_pick, resource_name)
  end

  def add_dhcp_subnet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:dhcp_subnet, :add, resource_name)
  end
end
