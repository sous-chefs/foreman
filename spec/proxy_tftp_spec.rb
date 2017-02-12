# -*- coding: utf-8 -*-
#
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
      expect(subject).to create_directory('/var/lib/tftpboot/pxelinux.cfg')
      expect(subject).to create_directory('/var/lib/tftpboot/boot')
    end

    it 'should retrieve bios components' do
      expect(subject).to cherry_pick_ark('pxelinux.0')
        .with(url: 'https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz',
              path: '/var/lib/tftpboot',
              creates: 'syslinux-6.03/bios/core/pxelinux.0')
      expect(subject).to cherry_pick_ark('menu.c32')
        .with(url: 'https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz',
              path: '/var/lib/tftpboot',
              creates: 'syslinux-6.03/bios/com32/menu/menu.c32')
      expect(subject).to cherry_pick_ark('chain.c32')
        .with(url: 'https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz',
              path: '/var/lib/tftpboot',
              creates: 'syslinux-6.03/bios/com32/chain/chain.c32')
    end
  end
end
