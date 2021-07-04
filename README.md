# Foreman cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/foreman.svg)](https://supermarket.chef.io/cookbooks/foreman)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/foreman/master.svg)](https://circleci.com/gh/sous-chefs/foreman)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Trying to reproduce [puppet-foreman_proxy](https://github.com/theforeman/puppet-foreman_proxy) and [puppet-foreman](https://github.com/theforeman/puppet-foreman) with Chef cookbooks.

Installs and configures Foreman and Foreman-smartproxy.

It can:

- Install and configure Foreman Web ui
- Install and configure a Foreman Smartproxy with dhcp, bmc, tftp, ...
- Register smartproxies

## Requirements

This cookbook depends on theses external cookbooks:

- apache2
- ark
- bind
- database
- dhcp
- git
- hostsfile
- mysql
- postgresql
- tftp

and requires:

- Chef > 12
- Ruby > 1.9

### Platform

Currently testing on Ubuntu, Debian.

## Usage

### Foreman web ui

```
include_recipe 'foreman'
```

### Install foreman smart proxy

Don't forget to edit attributes to be sure oauth have the same parameters and value as the foreman.

```
include_recipe 'foreman::proxy'
```

## Attributes

### `foreman::default`

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['foreman']['path']</tt></td>
    <td>String</td>
    <td>Foreman installation path</td>
    <td><tt>/usr/share/foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['version']</tt></td>
    <td>String</td>
    <td>Foreman version</td>
    <td><tt>stable</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['config_path']</tt></td>
    <td>String</td>
    <td>Configuration path</td>
    <td><tt>/etc/foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['config']['init']</tt></td>
    <td>String</td>
    <td>Init config path</td>
    <td><tt>/etc/default/foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['config']['init_tpl']</tt></td>
    <td>String</td>
    <td>Init config template</td>
    <td><tt>foreman.default.erb</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['use_repo']</tt></td>
    <td>Boolean</td>
    <td>Use Foreman repository</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['repo']['uri']</tt></td>
    <td>String</td>
    <td>Repository uri</td>
    <td><tt>http://deb.theforeman.org/</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['repo']['components']</tt></td>
    <td>Array</td>
    <td>Repository components</td>
    <td><tt>[stable]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['repo']['key']</tt></td>
    <td>String</td>
    <td>Repository key</td>
    <td><tt>http://deb.theforeman.org/foreman.asc</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['plugins']</tt></td>
    <td>Array</td>
    <td>Plugins installed via the package manager</td>
    <td><tt>[foreman-libvirt, ruby-foreman-chef]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['server_name']</tt></td>
    <td>String</td>
    <td>Server name to use for apache and fqdn</td>
    <td><tt>foreman.example</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['environment']</tt></td>
    <td>String</td>
    <td>Foreman environment</td>
    <td><tt>production</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['admin']['username']</tt></td>
    <td>String</td>
    <td>Admin username</td>
    <td><tt>admin</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['admin']['password']</tt></td>
    <td>String</td>
    <td>Admin password</td>
    <td><tt>changeme</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['admin']['first_name']</tt></td>
    <td>String</td>
    <td>Admin first name</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['admin']['last_name']</tt></td>
    <td>String</td>
    <td>Admin last name</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['admin']['email']</tt></td>
    <td>String</td>
    <td>Admin email</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['initial_organisation']</tt></td>
    <td>String</td>
    <td>Admin organisation</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['initial_location']</tt></td>
    <td>String</td>
    <td>Admin location</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['user']</tt></td>
    <td>String</td>
    <td>System user</td>
    <td><tt>foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['group']</tt></td>
    <td>String</td>
    <td>System group</td>
    <td><tt>foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['group_users']</tt></td>
    <td>Array</td>
    <td>System groups for foreman user</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['manage']</tt></td>
    <td>Boolean</td>
    <td>Manage the database</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['install']</tt></td>
    <td>Boolean</td>
    <td>Install the database</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['host']</tt></td>
    <td>String</td>
    <td>Database host</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['port']</tt></td>
    <td>String</td>
    <td>Database port</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['adapter']</tt></td>
    <td>String</td>
    <td>Database adapter</td>
    <td><tt>postgresql</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['real_adapter']</tt></td>
    <td>String</td>
    <td>Ruby adapter name</td>
    <td><tt>postgresql</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['ssl_mode']</tt></td>
    <td>Boolean</td>
    <td>Database in ssl</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['database']</tt></td>
    <td>String</td>
    <td>Database name</td>
    <td><tt>foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['db']['username']</tt></td>
    <td>String</td>
    <td>Database username</td>
    <td><tt>foreman</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['install']</tt></td>
    <td>Boolean</td>
    <td>Install apache passenger mod</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['high_performance']</tt></td>
    <td>Boolean</td>
    <td>Mod passenger high performance</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['rack_autodetect']</tt></td>
    <td>Boolean</td>
    <td>Mod passenger rack autodetect</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['max_pool_size']</tt></td>
    <td>Integer</td>
    <td>Mod passenger max pool size</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['pool_idle_time']</tt></td>
    <td>Integer</td>
    <td>Mod passenger pool idle time</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['max_requests']</tt></td>
    <td>Integer</td>
    <td>Mod passenger max requests</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['stat_throttle_rate']</tt></td>
    <td>Integer</td>
    <td>Mod passenger stat throttle rate</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['use_global_queue']</tt></td>
    <td>Boolean</td>
    <td>Mod passenger global queue</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['default_ruby']</tt></td>
    <td>String</td>
    <td>Mod passenger default ruby</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['prestart']</tt></td>
    <td>Boolean</td>
    <td>Mod passenger prestart</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['min_instances']</tt></td>
    <td>Integer</td>
    <td>Mod passenger minimum instances</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['start_timeout']</tt></td>
    <td>Integer</td>
    <td>Mod passenger start tiemout</td>
    <td><tt>600</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['ruby']</tt></td>
    <td>String</td>
    <td>Mod passenger ruby path</td>
    <td><tt>/usr/bin/ruby</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['passenger']['package']</tt></td>
    <td>String</td>
    <td>Mod passenger package</td>
    <td><tt>libapache2-mod-passenger</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl']</tt></td>
    <td>Boolean</td>
    <td>Foreman in Ssl</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl']</tt></td>
    <td>Boolean</td>
    <td>Foreman in Ssl</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_dir']</tt></td>
    <td>String</td>
    <td>Ssl directory</td>
    <td><tt>/etc/foreman/certs</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_ca_file']</tt></td>
    <td>String</td>
    <td>Ssl ca file</td>
    <td><tt>/etc/foreman/certs/ca.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_ca_key_file']</tt></td>
    <td>String</td>
    <td>Ssl ca key file</td>
    <td><tt>/etc/foreman/certs/ca.key</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_cert_file']</tt></td>
    <td>String</td>
    <td>Ssl cert file</td>
    <td><tt>/etc/foreman/certs/server.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_cert_key_file']</tt></td>
    <td>String</td>
    <td>Ssl cert key file</td>
    <td><tt>/etc/foreman/certs/server.key</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['ssl_cert_csr_file']</tt></td>
    <td>String</td>
    <td>Ssl cert csr file</td>
    <td><tt>/etc/foreman/certs/server.csr</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['unattended']</tt></td>
    <td>Boolean</td>
    <td>Foreman unattented</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['authentication']</tt></td>
    <td>Boolean</td>
    <td>Foreman authentication</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['locations_enabled']</tt></td>
    <td>Boolean</td>
    <td>Foreman enable locations</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['organizations_enabled']</tt></td>
    <td>Boolean</td>
    <td>Foreman enable organizations</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['oauth_active']</tt></td>
    <td>Boolean</td>
    <td>Foreman oauth</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['oauth_map_users']</tt></td>
    <td>Boolean</td>
    <td>Foreman oauth map users</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['oauth_consumer_key']</tt></td>
    <td>String</td>
    <td>Foreman oauth consumer key</td>
    <td><tt>Random string</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['oauth_consumer_secret']</tt></td>
    <td>String</td>
    <td>Foreman oauth consumer secret</td>
    <td><tt>Random string</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['websockets_encrypt']</tt></td>
    <td>Boolean</td>
    <td>Foreman encrypt websockets</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['websockets_ssl_key']</tt></td>
    <td>Boolean</td>
    <td>Foreman websockets ssl key</td>
    <td><tt>/etc/ssl/certs/foreman.example.pem</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman']['websockets_ssl_cert']</tt></td>
    <td>Boolean</td>
    <td>Foreman websockets ssl cert</td>
    <td><tt>/etc/ssl/privates_keys/foreman.example.pem</tt></td>
  </tr>
</table>

### `foreman::foreman_proxy`

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['version']</tt></td>
    <td>String</td>
    <td>Foreman proxy version</td>
    <td><tt>stable</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['register']</tt></td>
    <td>Boolean</td>
    <td>Register foreman proxy in foreman</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['config_path']</tt></td>
    <td>String</td>
    <td>Foreman proxy config path</td>
    <td><tt>/etc/foreman-proxy</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['daemon']</tt></td>
    <td>Boolean</td>
    <td>Foreman proxy daemon</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['user']</tt></td>
    <td>String</td>
    <td>Foreman proxy user</td>
    <td><tt>foreman-proxy</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['group']</tt></td>
    <td>String</td>
    <td>Foreman proxy group</td>
    <td><tt>foreman-proxy</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['group_users']</tt></td>
    <td>Array</td>
    <td>System groups for foreman-proxy user</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['plugins']</tt></td>
    <td>Array</td>
    <td>Plugins installed via the package manager for the smartproxy</td>
    <td><tt>[ruby-smart-proxy-chef]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['log_file']</tt></td>
    <td>String</td>
    <td>Log file</td>
    <td><tt>/var/log/foreman-proxy/proxy.log</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['log_level']</tt></td>
    <td>String</td>
    <td>Log level</td>
    <td><tt>ERROR</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetrun']</tt></td>
    <td>Boolean</td>
    <td>Puppetrun</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetrun_listen_on']</tt></td>
    <td>String</td>
    <td>Puppetrun listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetca']</tt></td>
    <td>Boolean</td>
    <td>Puppetca</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetca_listen_on']</tt></td>
    <td>String</td>
    <td>Puppetca listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet']</tt></td>
    <td>Boolean</td>
    <td>Puppet</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_home']</tt></td>
    <td>String</td>
    <td>Puppet home directory</td>
    <td><tt>/var/lib/puppet</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_url']</tt></td>
    <td>String</td>
    <td>Puppet url</td>
    <td><tt>https://foreman.example:8140</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_use_environement_api']</tt></td>
    <td>Boolean</td>
    <td>Puppet environment api</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_autosign_location']</tt></td>
    <td>String</td>
    <td>Puppet autosign location</td>
    <td><tt>/etc/puppet/autosign.conf</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_group']</tt></td>
    <td>String</td>
    <td>Puppet group</td>
    <td><tt>puppet</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppet_ssl_dir']</tt></td>
    <td>String</td>
    <td>Puppet ssl directory</td>
    <td><tt>/var/lib/puppet/ssl</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetssh_sudo']</tt></td>
    <td>Boolean</td>
    <td>Puppet ssh use sudo</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetssh_command']</tt></td>
    <td>String</td>
    <td>Puppet ssh command</td>
    <td><tt>/usr/bin/puppet agent --ontine --no-usecacheonfailure</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetssh_user']</tt></td>
    <td>String</td>
    <td>Puppet ssh user</td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetssh_keyfile']</tt></td>
    <td>String</td>
    <td>Puppet ssh key file</td>
    <td><tt>/etc/foreman-proxy/id_rsa</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['puppetssh_wait']</tt></td>
    <td>Boolean</td>
    <td>Puppet ssh wait</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['http']</tt></td>
    <td>Boolean</td>
    <td>Foreman http</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['http_port']</tt></td>
    <td>String</td>
    <td>Foreman http port</td>
    <td><tt>8000</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['ssl']</tt></td>
    <td>Boolean</td>
    <td>Foreman use ssl</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['https_port']</tt></td>
    <td>String</td>
    <td>Foreman ssl port</td>
    <td><tt>8443</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['ssl_ca_file']</tt></td>
    <td>String</td>
    <td>Foreman ssl ca file</td>
    <td><tt>/etc/foreman/certs/ca.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['ssl_cert_file']</tt></td>
    <td>String</td>
    <td>Foreman ssl cert file</td>
    <td><tt>/etc/foreman/certs/server.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['ssl_cert_key_file']</tt></td>
    <td>String</td>
    <td>Foreman ssl cert key file</td>
    <td><tt>/etc/foreman/certs/server.key</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['registered_name']</tt></td>
    <td>String</td>
    <td>Foreman proxy registered name</td>
    <td><tt>foreman.example</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['registered_proxy_url']</tt></td>
    <td>String</td>
    <td>Foreman proxy registered url</td>
    <td><tt>https://foreman.example:8443</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['foreman_base_url']</tt></td>
    <td>String</td>
    <td>Foreman base url</td>
    <td><tt>https://foreman.example</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['foreman_ssl_ca']</tt></td>
    <td>String</td>
    <td>Foreman ssl ca</td>
    <td><tt>/etc/foreman/certs/ca.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['foreman_ssl_cert']</tt></td>
    <td>String</td>
    <td>Foreman ssl cert</td>
    <td><tt>/etc/foreman/certs/server.crt</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['foreman_ssl_key']</tt></td>
    <td>String</td>
    <td>Foreman ssl key</td>
    <td><tt>/etc/foreman/certs/server.key</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['trusted_hosts']</tt></td>
    <td>Array</td>
    <td>Foreman proxy trusted hosts</td>
    <td><tt>[foreman.example]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['api_package']</tt></td>
    <td>String</td>
    <td>Apipie bindings ruby package</td>
    <td><tt>ruby-apipie-bindings</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns']</tt></td>
    <td>Boolean</td>
    <td>Install dns server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_listen_on']</tt></td>
    <td>String</td>
    <td>Dns listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_managed']</tt></td>
    <td>Boolean</td>
    <td>Dns is managed by Chef</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_provider']</tt></td>
    <td>String</td>
    <td>Dns provider</td>
    <td><tt>nsupdate</tt></td>
  </tr>

  <tr>
    <td><tt>['foreman-proxy']['dns_interface']</tt></td>
    <td>String</td>
    <td>Dns interface</td>
    <td><tt>eth0</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_ttl']</tt></td>
    <td>String</td>
    <td>Dns ttl</td>
    <td><tt>86400</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_server']</tt></td>
    <td>String</td>
    <td>Dns server</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_realm']</tt></td>
    <td>String</td>
    <td>Dns realm</td>
    <td><tt>FOREMAN.EXAMPLE</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_tsig_keytab']</tt></td>
    <td>String</td>
    <td>Dns tsig keytab</td>
    <td><tt>/etc/foreman-proxy/dns.keytab</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_tsig_principal']</tt></td>
    <td>String</td>
    <td>Dns tsig princial</td>
    <td><tt>foremanproxy/foreman.example@FOREMAN.EXAMPLE</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_keyfile']</tt></td>
    <td>String</td>
    <td>Dns key file</td>
    <td><tt>/etc/bind/rndc.key</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dns_nsupdate']</tt></td>
    <td>String</td>
    <td>Dns nsupdate</td>
    <td><tt>dnsutils</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp']</tt></td>
    <td>Boolean</td>
    <td>Proxy use dhcp</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_managed']</tt></td>
    <td>Boolean</td>
    <td>Install dhcp server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_key_name']</tt></td>
    <td>String</td>
    <td>Dhcp key name</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_key_secret']</tt></td>
    <td>String</td>
    <td>Dhcp key secret</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_vendor']</tt></td>
    <td>String</td>
    <td>Dhcp vendor</td>
    <td><tt>isc</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_config']</tt></td>
    <td>String</td>
    <td>Dhcp config file</td>
    <td><tt>node['dhcp']['config_file']</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_leases']</tt></td>
    <td>String</td>
    <td>Dhcp leases files</td>
    <td><tt>/var/lib/dhcp/dhcpd.leases</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_interface']</tt></td>
    <td>String</td>
    <td>Dhcp interface</td>
    <td><tt>eth0</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_subnet']</tt></td>
    <td>String</td>
    <td>Dhcp subnet</td>
    <td><tt>Ohai subnet</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_netmask']</tt></td>
    <td>String</td>
    <td>Dhcp netmask</td>
    <td><tt>Ohai netmask</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_broadcast']</tt></td>
    <td>String</td>
    <td>Dhcp broadcast</td>
    <td><tt>Ohai broadcast</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_range']</tt></td>
    <td>Array</td>
    <td>Dhcp range</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_routers']</tt></td>
    <td>Array</td>
    <td>Dhcp routers</td>
    <td><tt>[Ohai router]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['dhcp_options']</tt></td>
    <td>Array</td>
    <td>Dhcp options</td>
    <td><tt>...</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['virsh_network']</tt></td>
    <td>String</td>
    <td>Virsh network</td>
    <td><tt>default</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['bmc']</tt></td>
    <td>Boolean</td>
    <td>As bmc</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['bmc_listen_on']</tt></td>
    <td>String</td>
    <td>Bmc listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['bmc_default_provider']</tt></td>
    <td>String</td>
    <td>Bmc default provider</td>
    <td><tt>ipmitool</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['syslinux']['version']</tt></td>
    <td>String</td>
    <td>Syslinux version</td>
    <td><tt>6.03</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['syslinux']['url']</tt></td>
    <td>String</td>
    <td>Syslinux url</td>
    <td><tt>...</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['tftp']</tt></td>
    <td>Boolean</td>
    <td>As TFTP</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['tftp_listen_on']</tt></td>
    <td>String</td>
    <td>TFTP listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['tftp_syslinux_root']</tt></td>
    <td>String</td>
    <td>TFTP syslinux root</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['tftp_root']</tt></td>
    <td>String</td>
    <td>TFTP root</td>
    <td><tt>node['tftp']['directory']</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['tftp_dirs']</tt></td>
    <td>Array</td>
    <td>TFTP directories</td>
    <td><tt>[pxelinux.cfg, boot]</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['servername']</tt></td>
    <td>String</td>
    <td>TFTP servername</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['realm']</tt></td>
    <td>Boolean</td>
    <td>As Realm</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['real_listen_on']</tt></td>
    <td>String</td>
    <td>Realm listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['real_provider']</tt></td>
    <td>String</td>
    <td>Realm provider</td>
    <td><tt>freeipa</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['real_keytab']</tt></td>
    <td>String</td>
    <td>Realm keytab</td>
    <td><tt>/etc/foreman-proxy/freeipa.keytab</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['real_principal']</tt></td>
    <td>String</td>
    <td>Realm principal</td>
    <td><tt>real-proxy@EXAMPLE.COM</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['freeipa_remove_dns']</tt></td>
    <td>Boolean</td>
    <td>Freeipa remove dns</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['oauth_effective_user']</tt></td>
    <td>String</td>
    <td>Oauth effective user</td>
    <td><tt>admin</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['oauth_effective_user']</tt></td>
    <td>String</td>
    <td>Oauth effective user</td>
    <td><tt>admin</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['oauth_consumer_key']</tt></td>
    <td>String</td>
    <td>Oauth consumer key</td>
    <td><tt>Random password</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['oauth_consumer_secret']</tt></td>
    <td>String</td>
    <td>Oauth consumer secret</td>
    <td><tt>Random password</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['templates']</tt></td>
    <td>Boolean</td>
    <td>As templates</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['templates_listen_on']</tt></td>
    <td>String</td>
    <td>Templates listen on</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef']</tt></td>
    <td>Boolean</td>
    <td>As Chef</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_authenticate_nodes']</tt></td>
    <td>Boolean</td>
    <td>Use Chef authenticate nodes</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_server_url']</tt></td>
    <td>String</td>
    <td>Chef server url</td>
    <td><tt>https://chef.example.net</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_smartproxy_clientname']</tt></td>
    <td>String</td>
    <td>Chef client name</td>
    <td><tt>host.example.net</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_smartproxy_privatekey']</tt></td>
    <td>String</td>
    <td>Chef client private key</td>
    <td><tt>/etc/chef/client.pem</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_ssl_verify']</tt></td>
    <td>Boolean</td>
    <td>Verify chef ssl connection</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['foreman-proxy']['chef_ssl_pem_file']</tt></td>
    <td>String</td>
    <td>Chef ssl pem file</td>
    <td><tt>/etc/chef/chef.example.com.pem</tt></td>
  </tr>
</table>

## Resrouces/Providers

### `foreman_smartproxy`

This LWRP provides and easy way to register or unregister a smartproxy into foreman.

#### Actions

- `:create`, register the smartproxy
- `:remove`, unregister the smartproxy

#### Parameters

- `smartproxy_name`: Name of the smartproxy
- `base_url`: Base url of foreman web api
- `effective_user`: Foreman user
- `consumer_key`: Oauth key
- `consumer_secret`: Oauth secret
- `url`: Url of the smartproxy
- `timeout`: Request timeout

### `foreman_rake`

This LWRP reproduces the `foreman-rake` cli command.

#### Actions

- `:run`, run foreman-rake command

#### Parameters

- `rake_task`: Rake task name
- `environement`: Environement variables
- `timeout`: Request timeout

### `foreman_proxy_settings_file`

This LWRP enable or disable proxy settings files.

#### Actions

- `:enable`, enable setting file
- `:disable`, disable setting file

#### Parameters

- `module`: Module name
- `listen_on`: Module listen on which protocol
- `cookbook`: Cookbook where is stored the template file
- `path`: Path where the file will be created
- `owner`: File owner
- `group`: File group
- `mode`: File mode
- `template_path`: Template file path

## Authors

- [Pierre Rambaud](https://github.com/PierreRambaud)
- [Guilhem Lettron](https://github.com/guilhem)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
