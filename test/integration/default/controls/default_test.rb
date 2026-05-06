# frozen_string_literal: true

control 'foreman-default' do
  impact 1.0
  title 'Foreman application is installed and configured'

  describe package('foreman') do
    it { should be_installed }
  end

  describe package('foreman-postgresql') do
    it { should be_installed }
  end

  describe file('/etc/foreman/settings.yaml') do
    it { should exist }
    its('content') { should match(/:oauth_active: true/) }
  end

  describe file('/etc/foreman/database.yml') do
    it { should exist }
    its('content') { should match(/adapter: postgresql/) }
  end

  describe package('foreman-libvirt') do
    it { should be_installed }
  end

  describe package('ruby-foreman-ansible') do
    it { should be_installed }
  end
end
