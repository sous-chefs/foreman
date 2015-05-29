# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy_register' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new(UBUNTU_OPTS).converge(described_recipe)
    end

    it 'should register smartproxy' do
      expect(subject).to create_foreman_smartproxy('fauxhai.local')
        .with(base_url: 'https://foreman.example',
              effective_user: 'admin',
              url: 'https://fauxhai.local:8443')
    end
  end
end
