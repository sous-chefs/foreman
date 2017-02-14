# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy_config' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should includes recipes' do
      expect(subject).to include_recipe('foreman::proxy_tftp')
      expect(subject).to include_recipe('foreman::proxy_dhcp')
      expect(subject).to include_recipe('foreman::proxy_dns')
    end

    it 'should creates user and group' do
      expect(subject).to create_group('foreman-proxy')
        .with(members: ['bind'])
      expect(subject).to create_user('foreman-proxy')
        .with(shell: '/bin/bash',
              group: 'foreman-proxy')
    end

    it 'should disable proxy settings file' do
      expect(subject).to disable_foreman_proxy_settings_file('bmc')
        .with(listen_on: 'https')
      expect(subject).to disable_foreman_proxy_settings_file('puppet')
        .with(listen_on: 'https')
      expect(subject).to disable_foreman_proxy_settings_file('puppetca')
        .with(listen_on: 'https')
      expect(subject).to disable_foreman_proxy_settings_file('templates')
        .with(listen_on: 'https')
      expect(subject).to disable_foreman_proxy_settings_file('realm')
        .with(listen_on: 'https')
    end

    it 'should enable proxy settings file' do
      expect(subject).to enable_foreman_proxy_settings_file('dhcp')
        .with(listen_on: 'https')
      expect(subject).to enable_foreman_proxy_settings_file('dns')
        .with(listen_on: 'https')
      expect(subject).to enable_foreman_proxy_settings_file('tftp')
        .with(listen_on: 'https')
      expect(subject).to enable_foreman_proxy_settings_file('chef')
    end

    it 'should create settings file' do
      expect(subject).to create_template('/etc/foreman-proxy/settings.yml')
        .with(group: 'foreman-proxy',
              source: 'settings_foreman-proxy.yml.erb')
    end
  end
end
