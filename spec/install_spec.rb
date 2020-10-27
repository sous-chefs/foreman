require_relative 'spec_helper'

describe 'foreman::install' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should include recipes' do
      expect(subject).to include_recipe('foreman::repo')
    end

    it 'should install packages' do
      expect(subject).to install_package('foreman')
      expect(subject).to install_package('foreman-postgresql')
      expect(subject).to install_package('libapache2-mod-passenger')
    end
  end
end
