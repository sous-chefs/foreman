require 'fileutils'

require 'chefspec'
require 'rspec/expectations'

ChefSpec::Coverage.start!

SPEC_COOKBOOK_ROOT = File.expand_path('../tmp/spec-cookbooks', __dir__)
SPEC_COOKBOOKS = {
  'foreman' => File.expand_path('..', __dir__),
  'test' => File.expand_path('../test/cookbooks/test', __dir__),
  'apache2' => File.expand_path('../../apache2', __dir__),
  'tftp' => File.expand_path('../../tftp', __dir__),
}.freeze

STUB_COOKBOOKS = %w(
  apparmor
  bind
  database
  dhcp
  hostname
  hostsfile
  mysql
  mysql2_chef_gem
  postgresql
  yum
  yum-epel
).freeze

FileUtils.rm_rf(SPEC_COOKBOOK_ROOT)
FileUtils.mkdir_p(SPEC_COOKBOOK_ROOT)
SPEC_COOKBOOKS.each do |cookbook_name, cookbook_path|
  FileUtils.ln_sf(cookbook_path, File.join(SPEC_COOKBOOK_ROOT, cookbook_name))
end

STUB_COOKBOOKS.each do |cookbook_name|
  cookbook_root = File.join(SPEC_COOKBOOK_ROOT, cookbook_name)
  FileUtils.mkdir_p(cookbook_root)
  File.write(File.join(cookbook_root, 'metadata.rb'), <<~RUBY)
    name '#{cookbook_name}'
    version '0.1.0'
    chef_version '>= 15.3'
  RUBY
end

COOKBOOK_PATHS = [SPEC_COOKBOOK_ROOT].freeze

def solo_runner(options = {}, &block)
  ChefSpec::SoloRunner.new({ cookbook_path: COOKBOOK_PATHS }.merge(options), &block)
end

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '22.04'
  config.log_level = :fatal
end

shared_context 'common_stubs' do
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
  end
end
