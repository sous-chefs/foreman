require 'spec_helper'

describe group('foreman-proxy') do
  it { should exist }
end

describe user('foreman-proxy') do
  it { should exist }
end

describe port('8443') do
  it { should be_listening }
end

describe file('/etc/foreman-proxy/settings.yml') do
  it { should be_grouped_into 'foreman-proxy' }
  its(:content) { should match(/^:https_port: 8443$/) }
  its(:content) { should match(%r{^:ssl_ca_file: /etc/foreman/certs/ca.crt$}) }
  its(:content) { should match(%r{^:ssl_certificate: /etc/foreman/certs/server.crt$}) }
  its(:content) { should match(%r{^:ssl_private_key: /etc/foreman/certs/server.key$}) }
  its(:content) { should match(%r{^:foreman_url: https://foreman.example$}) }
  its(:content) { should match(%r{^:foreman_ssl_ca: /etc/foreman/certs/ca.crt$}) }
  its(:content) { should match(%r{^:foreman_ssl_cert: /etc/foreman/certs/server.crt$}) }
  its(:content) { should match(%r{^:foreman_ssl_key: /etc/foreman/certs/server.key$}) }
end

%w(bmc puppetca puppet realm templates).each do |type|
  describe file("/etc/foreman-proxy/settings.d/#{type}.yml") do
    it { should be_grouped_into 'foreman-proxy' }
    its(:content) { should match(/^:enabled: false$/) }
  end
end

%w(dhcp dns tftp).each do |type|
  describe file("/etc/foreman-proxy/settings.d/#{type}.yml") do
    it { should be_grouped_into 'foreman-proxy' }
    its(:content) { should match(/^:enabled: https$/) }
  end
end
