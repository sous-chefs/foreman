# -*- coding: utf-8 -*-
#
require 'spec_helper'

describe group('foreman') do
  it { should exist }
end

describe user('foreman') do
  it { should exist }
end

describe port('443') do
  it { should be_listening }
end

describe file('/etc/foreman/settings.yaml') do
  it { should be_grouped_into 'foreman' }
  its(:content) { should match(%r{^:ssl_ca_file: /etc/foreman/certs/ca.crt$}) }
  its(:content) { should match(%r{^:ssl_certificate: /etc/foreman/certs/server.crt$}) }
  its(:content) { should match(%r{^:ssl_priv_key: /etc/foreman/certs/server.key$}) }
  its(:content) { should match(%r{^:oauth_active: true$}) }
end
