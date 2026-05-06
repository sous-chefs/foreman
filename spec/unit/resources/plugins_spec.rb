# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'foreman_plugins resource' do
  cached(:chef_run) do
    solo_runner(step_into: ['foreman_plugins']).converge('test::unit_plugins')
  end

  it 'installs configured plugins' do
    expect(chef_run).to install_package('foreman-libvirt')
    expect(chef_run).to install_package('ruby-foreman-chef')
  end
end
