# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy_install' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should includes recipes' do
      expect(subject).to include_recipe('foreman::repo')
    end

    it 'should install packages' do
      expect(subject).to install_package('foreman-proxy')
      expect(subject).to install_package('ruby-apipie-bindings')
      expect(subject).to install_package('ruby-smart-proxy-chef')
      expect(subject).to_not install_package('ipmitool')
    end
  end
end
