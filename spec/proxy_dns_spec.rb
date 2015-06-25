# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::proxy_dns' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new(UBUNTU_OPTS).converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('bind')
    end

    it 'should create entry in /etc/hosts' do
      expect(subject).to append_hostsfile_entry('127.0.0.1')
        .with(hostname: 'foreman.example')
    end
  end
end
