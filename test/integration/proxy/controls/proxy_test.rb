# frozen_string_literal: true

control 'foreman-proxy' do
  impact 1.0
  title 'Foreman proxy is installed and configured'

  describe package('foreman-proxy') do
    it { should be_installed }
  end

  describe service('foreman-proxy') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/foreman-proxy/settings.yml') do
    it { should exist }
    its('content') { should match(%r{:foreman_url: https://foreman.example}) }
  end

  describe file('/etc/foreman-proxy/settings.d/dhcp.yml') do
    it { should exist }
    its('content') { should match(/:enabled: https/) }
  end

  describe file('/etc/foreman-proxy/settings.d/dns.yml') do
    it { should exist }
    its('content') { should match(/:enabled: https/) }
  end

  describe file('/etc/foreman-proxy/settings.d/tftp.yml') do
    it { should exist }
    its('content') { should match(/:enabled: https/) }
  end
end
