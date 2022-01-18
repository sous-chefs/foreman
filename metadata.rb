name              'foreman'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures foreman'
source_url        'https://github.com/sous-chefs/foreman'
issues_url        'https://github.com/sous-chefs/foreman/issues'
chef_version      '>= 12.1'
version           '0.1.0'

supports 'ubuntu'

depends 'apt'
depends 'apache2'
depends 'bind'
depends 'database'
depends 'dhcp'
depends 'git'
depends 'hostname'
depends 'hostsfile'
depends 'mysql'
depends 'mysql2_chef_gem'
depends 'postgresql'
depends 'tftp'
