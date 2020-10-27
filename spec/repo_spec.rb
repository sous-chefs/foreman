require_relative 'spec_helper'

describe 'foreman::repo' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should add repositories' do
      expect(subject).to add_apt_repository('foreman')
        .with(uri: 'http://deb.theforeman.org/',
              distribution: 'trusty',
              componenets: nil,
              key: 'http://deb.theforeman.org/foreman.asc')
      expect(subject).to add_apt_repository('foreman_plugins')
        .with(uri: 'http://deb.theforeman.org/',
              distribution: 'plugins',
              componenets: nil,
              key: 'http://deb.theforeman.org/foreman.asc')
    end
  end
end
