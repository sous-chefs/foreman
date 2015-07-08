# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: database
#
db = node['foreman']['db']
if db['manage']
  if db['adapter'] == 'mysql'
    mysql2_chef_gem 'default' do
      action :install
    end

    mysql_client 'default' do
      action :create
    end

    mysql_service 'default' do
      initial_root_password db['password']
      action [:create, :start]
    end

    connection_info = {
      host: '127.0.0.1',
      username: 'root',
      password: db['password'],
      socket: '/var/run/mysql-default/mysqld.sock'
    }

    mysql_database_user 'create-foremanuser' do
      username db['username']
      password db['password']
      host db['host']
      connection connection_info
      action :create
    end

    mysql_database db['database'] do
      connection connection_info
      owner db['username']
      action :create
    end

    mysql_database_user 'grant-foremanuser' do
      username db['username']
      password db['password']
      database_name db['database']
      privileges [:all]
      connection connection_info
      action :grant
    end
  elsif db['adapter'] == 'postgresql'
    include_recipe 'database::postgresql'
    include_recipe 'postgresql::server'
    connection_info = {
      host: '127.0.0.1',
      port: 5432,
      username: 'postgres',
      password: node['postgresql']['password']['postgres']
    }

    postgresql_database_user 'create-foremanuser' do
      username db['username']
      password db['password']
      host db['host']
      connection connection_info
      action :create
    end

    postgresql_database db['database'] do
      connection connection_info
      owner db['username']
      action :create
    end

    postgresql_database_user 'grant-foremanuser' do
      username db['username']
      password db['password']
      database_name db['database']
      privileges [:all]
      connection connection_info
      action :grant
    end
  end

  gem_package "activerecord-#{db['real_adapter']}-adapter"
  foreman_rake 'db:migrate'
  seed_env = {
    'SEED_ADMIN_USER' => node['foreman']['admin']['username'],
    'SEED_ADMIN_PASSWORD' => node['foreman']['admin']['password'],
    'SEED_ADMIN_FIRST_NAME' => node['foreman']['admin']['first_name'],
    'SEED_ADMIN_LAST_NAME' => node['foreman']['admin']['last_name'],
    'SEED_ADMIN_EMAIL' => node['foreman']['admin']['email'],
    'SEED_ORGANIZATION' => node['foreman']['initial_organization'],
    'SEED_LOCATION' => node['foreman']['initial_location']
  }

  foreman_rake 'db:seed' do
    environment seed_env
  end

  foreman_rake 'apipie:cache'
end
