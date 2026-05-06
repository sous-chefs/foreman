# frozen_string_literal: true

require 'fileutils'

require 'chefspec'
require 'rspec/expectations'

ChefSpec::Coverage.start!

SPEC_COOKBOOK_ROOT = File.expand_path('../tmp/spec-cookbooks', __dir__)
SPEC_COOKBOOKS = {
  'foreman' => File.expand_path('..', __dir__),
  'test' => File.expand_path('../test/cookbooks/test', __dir__),
}.freeze

STUB_COOKBOOKS = %w(
  apache2
  apparmor
  bind
  database
  dhcp
  hostname
  hostsfile
  mysql
  mysql2_chef_gem
  postgresql
  tftp
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
  FileUtils.mkdir_p(File.join(cookbook_root, 'recipes'))
  FileUtils.mkdir_p(File.join(cookbook_root, 'resources'))

  File.write(File.join(cookbook_root, 'metadata.rb'), <<~RUBY)
    name '#{cookbook_name}'
    version '0.1.0'
    chef_version '>= 15.3'
  RUBY

  File.write(File.join(cookbook_root, 'recipes', 'default.rb'), '')
  File.write(File.join(cookbook_root, 'recipes', 'server.rb'), '') if %w(tftp dhcp postgresql).include?(cookbook_name)

  case cookbook_name
  when 'apache2'
    %w(install module site service).each do |res|
      default_action = res == 'install' ? 'install' : 'enable'
      File.write(File.join(cookbook_root, 'resources', "#{res}.rb"), <<~RUBY)
        provides :apache2_#{res}
        unified_mode true
        action(:#{default_action}) {}
        action(:install) {}
        action(:create) {}
        action(:enable) {}
        action(:start) {}
        action(:reload) {}
      RUBY
    end
  when 'dhcp'
    File.write(File.join(cookbook_root, 'resources', 'subnet.rb'), <<~RUBY)
      provides :dhcp_subnet
      unified_mode true
      action(:add) {}
    RUBY
  end
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
