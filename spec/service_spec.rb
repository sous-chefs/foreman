# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::service' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new().converge(described_recipe)
    end

    it 'should restart services' do
      expect(subject).to restart_service('foreman')
    end
  end
end
