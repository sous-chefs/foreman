# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'foreman::install' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    let(:fix_ruby_trusty_bash_code) do
      %(
       rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb
        ln -s /usr/bin/ruby2.0 /usr/bin/ruby
        ln -s /usr/bin/gem2.0 /usr/bin/gem
        ln -s /usr/bin/irb2.0 /usr/bin/irb
        ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc
        ln -s /usr/bin/erb2.0 /usr/bin/erb
      ).gsub(/^\s{6}/, '')
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('foreman::repo')
      expect(subject).to include_recipe('apache2')
    end

    it 'should fix Ruby on Trusty if running Ruby 1.9' do
      expect(subject).to run_bash('Handle broken Ruby 2.0 in Trusty.').with(
        code: fix_ruby_trusty_bash_code
      )
    end

    it 'should install packages' do
      expect(subject).to install_package('ruby2.0')
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
