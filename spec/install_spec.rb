# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::install' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('foreman::repo')
      expect(subject).to include_recipe('apache2')
    end

    it 'should install packages' do
      expect(subject).to install_package('foreman')
      expect(subject).to install_package('foreman-postgresql')
      expect(subject).to install_package('libapache2-mod-passenger')
    end

    it 'should remove apache configuration' do
      expect(subject).to run_execute('remove-other-vhost')
        .with(command: 'a2disconf other-vhosts-access-log && sleep 2')
    end
  end
end
