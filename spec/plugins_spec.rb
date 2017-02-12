# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::plugins' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new().converge(described_recipe)
    end

    it 'should install packages' do
      expect(subject).to install_package('foreman-libvirt')
      expect(subject).to install_package('ruby-foreman-chef')
    end
  end
end
