source 'https://rubygems.org'

gem 'chef', '12.2.1' #TODO wait Chef zero to use 12.3

group :integration do
  gem 'berkshelf'
  gem 'rubocop'
  gem 'rake'
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'serverspec'
  gem 'chefspec'
  gem 'foodcritic'
end

group :example do
  gem 'chef-provisioning', github: 'chef/chef-provisioning'
  gem 'chef-provisioning-vagrant', '~> 0.8.1'
end
