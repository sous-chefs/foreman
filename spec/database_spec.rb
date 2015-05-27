# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::database' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new(UBUNTU_OPTS).converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('database::postgresql')
      expect(subject).to include_recipe('postgresql::server')
    end

    it 'should install gems' do
      expect(subject).to install_gem_package('activerecord-postgresql-adapter')
    end

    it 'should configure postgresql' do
      expect(subject).to create_postgresql_database('foreman')
      expect(subject).to create_postgresql_database_user('create-foremanuser')
        .with(username: 'foreman',
              password: 'foreman',
              host: 'localhost',
              database_name: 'foreman')
      expect(subject).to grant_postgresql_database_user('grant-foremanuser')
        .with(username: 'foreman',
              password: 'foreman',
              database_name: 'foreman',
              privileges: [:all])
    end

    it 'should run rake tasks' do
      expect(subject).to run_foreman_rake('db:migrate')
      expect(subject).to run_foreman_rake('db:seed')
        .with(environment: {
                'SEED_ADMIN_USER' => 'admin',
                'SEED_ADMIN_PASSWORD' => 'changeme',
                'SEED_ADMIN_FIRST_NAME' => nil,
                'SEED_ADMIN_LAST_NAME' => nil,
                'SEED_ADMIN_EMAIL' => nil,
                'SEED_ORGANIZATION' => nil,
                'SEED_LOCATION' => nil
              })
      expect(subject).to run_foreman_rake('apipie:cache')
    end
  end
end
