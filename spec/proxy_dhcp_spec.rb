# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy_dhcp' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new().converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('dhcp::server')
    end

    it 'should create subnet' do
      expect(subject).to add_dhcp_subnet('foreman')
        .with(subnet: '10.0.2.0',
              netmask: '255.255.255.0',
              broadcast: '10.0.2.255',
              routers: ['10.0.2.15'],
              options: ['domain-name "foreman.example"',
                        'domain-name-servers 127.0.0.1, 8.8.8.8'])
    end
  end
end
