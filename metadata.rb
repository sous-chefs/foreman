name             'foreman'
maintainer       'Guilhem Lettron'
maintainer_email 'guilhem.lettron@optiflows.com'
license          'Apache v2'
description      'Installs/Configures foreman'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

#depends "application_ruby"

depends "uwsgi"
depends "git"
depends "ruby_install"
depends "apt"
depends "tftp"
depends "bind"
depends "dhcp"
depends "ark"
depends "hostname"
