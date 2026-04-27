require_relative '../../spec_helper'

describe 'foreman_repo resource' do
  cached(:chef_run) do
    runner = solo_runner(step_into: ['foreman_repo']) do |node|
      node.automatic['lsb'] = { 'codename' => 'bookworm' }
    end

    runner.converge('test::unit_repo')
  end

  it 'creates foreman apt repositories' do
    expect(chef_run).to add_apt_repository('foreman')
    expect(chef_run).to add_apt_repository('foreman_plugins')
  end
end
