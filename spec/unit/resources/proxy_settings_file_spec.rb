# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'foreman_proxy_settings_file resource' do
  cached(:chef_run) do
    solo_runner(step_into: ['foreman_proxy_settings_file']).converge('test::unit_proxy_settings_file')
  end

  it 'renders the module template' do
    expect(chef_run).to create_template('/etc/foreman-proxy/settings.d/dns.yml')
  end
end
