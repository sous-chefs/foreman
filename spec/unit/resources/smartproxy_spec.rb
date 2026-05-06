# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'foreman_smartproxy resource' do
  cached(:chef_run) do
    stub_const('ApipieBindings', Module.new) unless defined?(ApipieBindings)
    stub_const('ApipieBindings::API', Class.new)

    api = instance_double('ApipieBindings::Resource')
    api_client = instance_double('ApipieBindings::API')

    allow(ApipieBindings::API).to receive(:new).and_return(api_client)
    allow(api_client).to receive(:resource).with(:smart_proxies).and_return(api)
    allow(api).to receive(:call).with(:index, search: 'name=proxy.example').and_return('results' => [])
    allow(api).to receive(:call).with(:create, smart_proxy: { 'name' => 'proxy.example', 'url' => 'https://proxy.example:8443' })

    solo_runner(step_into: ['foreman_smartproxy']).converge('test::unit_smartproxy')
  end

  it 'installs the API gem' do
    expect(chef_run).to install_chef_gem('apipie-bindings')
  end
end
