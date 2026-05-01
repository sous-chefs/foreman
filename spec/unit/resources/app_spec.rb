require_relative '../../spec_helper'

describe 'foreman_app resource' do
  include_context 'common_stubs'

  cached(:chef_run) do
    solo_runner(step_into: ['foreman_app']) do |node|
      node.normal['postgresql'] = { 'password' => { 'postgres' => 'toor' } }
    end.converge('test::unit_app')
  end

  it 'configures the foreman application' do
    expect(chef_run).to create_foreman_repo('foreman-repository')
    expect(chef_run).to install_package('foreman')
    expect(chef_run).to install_package('foreman-postgresql')

    expect(chef_run).to install_apache2_install('default')
    expect(chef_run).to install_package('libapache2-mod-passenger')

    expect(chef_run).to create_user('foreman')

    expect(chef_run).to create_directory('/etc/foreman')
    expect(chef_run).to create_template('/etc/foreman/settings.yaml')
    expect(chef_run).to create_template('/etc/foreman/database.yml')
    expect(chef_run).to create_template('/etc/default/foreman')

    expect(chef_run).to create_directory('/etc/apache2/05-foreman.d')
    expect(chef_run).to create_template('/etc/apache2/mods-available/passenger_extra.conf')
    expect(chef_run).to enable_apache2_module('passenger')
    expect(chef_run).to enable_apache2_module('ssl')

    expect(chef_run).to create_template('/etc/apache2/sites-available/foreman.conf')
    expect(chef_run).to enable_apache2_site('foreman.conf')

    expect(chef_run).to enable_service('foreman')
    expect(chef_run).to start_service('foreman')

    expect(chef_run).to enable_apache2_service('default')
    expect(chef_run).to start_apache2_service('default')
  end
end
