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
              group: 'foreman')
    end

    it 'should create directoy' do
      expect(subject).to create_directory('/etc/foreman')
        .with(owner: 'root',
              group: 'root')
    end

    it 'should creates templates' do
      expect(subject).to create_template('/etc/foreman/settings.yaml')
        .with(group: 'foreman',
              source: 'settings_foreman.yaml.erb')
      expect(subject).to create_template('/etc/foreman/database.yml')
        .with(group: 'foreman',
              source: 'database_foreman.yml.erb',
              variables: { real_adapter: 'postgresql' })
      expect(subject).to create_template('/etc/default/foreman')
        .with(source: 'foreman.default.erb')
    end

    it 'should configure mod passenger' do
      expect(subject).to create_directory('/etc/apache2/05-foreman.d')
        .with(owner: 'root',
              group: 'root',
              mode: '0644')

      expect(subject).to create_template('/etc/apache2/mods-available/passenger_extra.conf')
        .with(source: 'passenger.conf.erb')
    end

    it 'should configure ssl' do
      expect(subject).to create_directory('/etc/foreman/certs')
        .with(owner: 'www-data',
              group: 'www-data')

      expect(subject).to run_execute('create-ca-key')
        .with(command: 'openssl genrsa -out /etc/foreman/certs/ca.key 4096')
      expect(subject).to run_execute('create-ca-crt')
        .with(command: "openssl req -new -x509 -nodes -days 1826 -key /etc/foreman/certs/ca.key -out /etc/foreman/certs/ca.crt -subj '/C=US/ST=Denial/L=Springfield/O=Dis/CN=foreman.example'")
      expect(subject).to run_execute('create-server-key')
        .with(command: 'openssl genrsa -out /etc/foreman/certs/server.key 2048')
      expect(subject).to run_execute('create-server-csr')
        .with(command: "openssl req -new -key /etc/foreman/certs/server.key -out /etc/foreman/certs/server.csr -subj '/CN=foreman.example'")
      expect(subject).to run_execute('create-server-crt')
        .with(command: 'openssl x509 -req -in /etc/foreman/certs/server.csr -CA /etc/foreman/certs/ca.crt -CAkey /etc/foreman/certs/ca.key -CAcreateserial -out /etc/foreman/certs/server.crt -days 1826')
      expect(subject).to run_execute('update-ca-certificates')
        .with(command: "cp /etc/foreman/certs/ca.crt /usr/share/ca-certificates/foreman.example.crt ; echo 'foreman.example.crt' >> /etc/ca-certificates.conf ; update-ca-certificates -f")
    end
  end
end
