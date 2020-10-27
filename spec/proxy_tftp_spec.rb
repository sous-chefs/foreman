require_relative 'spec_helper'

describe 'foreman::proxy_tftp' do
  include_context 'foreman_stubs'

  describe 'ubuntu' do
    cached(:subject) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'should includes recipes' do
      expect(subject).to include_recipe('tftp')
    end

    it 'should create directories' do
      expect(subject).to create_directory('/var/lib/tftpboot')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')

      expect(subject).to create_directory('/var/lib/tftpboot/pxelinux.cfg')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')

      expect(subject).to create_directory('/var/lib/tftpboot/boot')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')
    end

    it 'should install the package syslinux-common' do
      expect(subject).to install_package('syslinux-common')
    end

    it 'should retrieve Syslinux components' do
      expect(subject).to create_link('/var/lib/tftpboot/pxelinux.0')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')

      expect(subject).to create_link('/var/lib/tftpboot/menu.c32')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')

      expect(subject).to create_link('/var/lib/tftpboot/chain.c32')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')

      expect(subject).to create_link('/var/lib/tftpboot/memdisk')
        .with(owner: 'foreman-proxy',
              group: 'foreman-proxy')
    end
  end
end
