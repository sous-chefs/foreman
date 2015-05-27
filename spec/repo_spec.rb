# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::repo' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new(UBUNTU_OPTS).converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('apt')
    end

    it 'should add repository' do
      expect(subject).to add_apt_repository('foreman')
        .with(uri: 'http://deb.theforeman.org/',
              distribution: 'trusty',
              componenets: nil,
              key: 'http://deb.theforeman.org/foreman.asc')
    end
  end
end
