# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'foreman_rake resource' do
  cached(:chef_run) do
    solo_runner(step_into: ['foreman_rake']).converge('test::unit_rake')
  end

  it 'executes the rake task' do
    expect(chef_run).to run_execute('foreman-rake-db:migrate').with(
      command: '/usr/sbin/foreman-rake db:migrate'
    )
  end
end
