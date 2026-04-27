control 'foreman-default' do
  impact 1.0
  title 'Foreman application is installed and configured'

  describe package('foreman') do
    it { should be_installed }
  end

  describe package('foreman-postgresql') do
    it { should be_installed }
  end

  describe service('foreman') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/foreman/settings.yaml') do
    it { should exist }
    its('content') { should match(/:oauth_active: true/) }
  end

  describe file('/etc/foreman/database.yml') do
    it { should exist }
    its('content') { should match(/adapter: postgresql/) }
  end

  describe package('ruby-foreman-chef') do
    it { should be_installed }
  end
end
