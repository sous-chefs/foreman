require_relative '../../spec_helper'

describe 'foreman_proxy resource' do
  include_context 'common_stubs'

  cached(:chef_run) do
    solo_runner(step_into: ['foreman_proxy']) do |node|
      node.normal['network'] = {
        'interfaces' => {
          'eth0' => {
            'addresses' => {
              '10.0.0.2' => {
                'netmask' => '255.255.255.0',
                'broadcast' => '10.0.0.255',
              },
            },
            'routes' => [{ 'src' => '10.0.0.2', 'destination' => '10.0.0.0/24' }],
          },
        },
      }
    end.converge('test::unit_proxy')
  end

  it 'configures the smart proxy' do
    expect(chef_run).to install_package('foreman-proxy')
    expect(chef_run).to create_template('/etc/foreman-proxy/settings.yml')
    expect(chef_run).to enable_service('foreman-proxy')
    expect(chef_run).to start_service('foreman-proxy')
  end

  it 'renders managed proxy modules' do
    expect(chef_run).to enable_foreman_proxy_settings_file('dhcp')
    expect(chef_run).to enable_foreman_proxy_settings_file('dns')
    expect(chef_run).to enable_foreman_proxy_settings_file('tftp')
  end
end
