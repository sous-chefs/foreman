# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new().converge(described_recipe)
    end

    it 'should includes recipes' do
      expect(subject).to include_recipe('foreman::proxy_install')
      expect(subject).to include_recipe('foreman::proxy_config')
      expect(subject).to include_recipe('foreman::proxy_service')
      expect(subject).to include_recipe('foreman::proxy_register')
    end
  end
end
