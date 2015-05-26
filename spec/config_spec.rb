# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::config' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new(UBUNTU_OPTS).converge(described_recipe)
    end

    it 'should creates user and group' do
      expect(subject).to create_group('foreman')
      expect(subject).to create_user('foreman')
        .with(shell: '/bin/bash',
              group: 'foreman',
              supports: { manage_home: true },
              home: '/home/foreman')
    end

    it 'should creates templates' do
      expect(subject).to create_template('/etc/foreman/settings.yaml')
        .with(group: 'foreman',
              source: 'settings_foreman.yaml.erb')
      expect(subject).to create_template('/etc/foreman/database.yml')
        .with(group: 'foreman',
              source: 'database_foreman.yml.erb',
              variables: { real_adapter: 'postgresql' })
    end
  end
end
