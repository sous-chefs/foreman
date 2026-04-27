require_relative '../../spec_helper'

describe 'foreman_app resource' do
  include_context 'common_stubs'

  cached(:chef_run) do
    solo_runner(step_into: ['foreman_app']) do |node|
      node.normal['postgresql'] = { 'password' => { 'postgres' => 'toor' } }
    end.converge('test::unit_app')
  end

  it 'configures the foreman application' do
    expect(chef_run).to install_package('foreman')
    expect(chef_run).to create_template('/etc/foreman/settings.yaml')
    expect(chef_run).to create_template('/etc/foreman/database.yml')
    expect(chef_run).to enable_service('foreman')
    expect(chef_run).to start_service('foreman')
  end
end
