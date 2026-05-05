# frozen_string_literal: true

provides :foreman_proxy
unified_mode true

use '_partial/_repository'

property :version, String
property :config_path, String, default: '/etc/foreman-proxy'
property :daemon, [true, false], default: true
property :user, String, default: 'foreman-proxy'
property :group, String, default: 'foreman-proxy'
property :group_users, Array, default: []
property :plugins, Array, default: []
property :register, [true, false], default: true
property :api_package, String, default: 'ruby-apipie-bindings'
property :service_name, String, default: 'foreman-proxy'
property :server_name, String, default: 'foreman.example'
property :http_enabled, [true, false], default: false
property :http_port, [String, Integer], default: '8000'
property :ssl_enabled, [true, false], default: true
property :https_port, [String, Integer], default: '8443'
property :trusted_hosts, Array, default: lazy { [server_name] }
property :foreman_base_url, String
property :registered_name, String
property :registered_proxy_url, String
property :oauth_effective_user, String, default: 'admin'
property :oauth_consumer_key, String, sensitive: true
property :oauth_consumer_secret, String, sensitive: true
property :virsh_network, String, default: 'default'
property :log_file, String, default: '/var/log/foreman-proxy/proxy.log'
property :log_level, String, default: 'ERROR'
property :ssl, Hash, default: {}
property :dns, Hash, default: {}
property :dhcp, Hash, default: {}
property :tftp, Hash, default: {}
property :bmc, Hash, default: {}
property :chef_module, Hash, default: {}
property :puppet, Hash, default: {}
property :puppetca, Hash, default: {}
property :realm, Hash, default: {}
property :templates_module, Hash, default: {}
property :ssl_data_bag_name, String, default: 'foreman-proxy'
property :ssl_data_bag_item, String, default: lazy { node.chef_environment }

action_class do
  include ForemanCookbook::Helpers

  def merged_ssl
    deep_merge(
      {
        ca_file: '/etc/foreman/certs/ca.crt',
        cert_file: '/etc/foreman/certs/server.crt',
        cert_key_file: '/etc/foreman/certs/server.key',
        foreman_ssl_ca: '/etc/foreman/certs/ca.crt',
        foreman_ssl_cert: '/etc/foreman/certs/server.crt',
        foreman_ssl_key: '/etc/foreman/certs/server.key',
      },
      symbolize_keys(new_resource.ssl)
    )
  end

  def network_settings(interface_name)
    iface = node.dig('network', 'interfaces', interface_name) || {}
    ip_addr = iface.fetch('addresses', {}).keys.find { |value| value.match?(/\A\d+\.\d+\.\d+\.\d+\z/) }
    route = Array(iface['routes']).find { |entry| entry.key?('src') && entry['src'] == ip_addr }

    {
      ip: ip_addr,
      subnet: route ? route['destination'].split('/').first : nil,
      netmask: ip_addr ? iface.dig('addresses', ip_addr, 'netmask') : nil,
      broadcast: ip_addr ? iface.dig('addresses', ip_addr, 'broadcast') : nil,
      router: route ? route['src'] : nil,
    }
  end

  def merged_dns
    fqdn = node['fqdn']
    realm = fqdn.nil? ? '' : fqdn.upcase

    deep_merge(
      {
        enabled: true,
        managed: true,
        listen_on: 'https',
        provider: 'nsupdate',
        interface: 'eth0',
        server: '127.0.0.1',
        ttl: '86400',
        realm: realm,
        tsig_keytab: '/etc/foreman-proxy/dns.keytab',
        tsig_principal: "foremanproxy/#{fqdn}@#{realm}",
        keyfile: '/etc/bind/rndc.key',
        bind_user: 'bind',
      },
      symbolize_keys(new_resource.dns)
    )
  end

  def merged_dhcp
    dhcp_overrides = symbolize_keys(new_resource.dhcp)
    net = network_settings((dhcp_overrides[:interface] || 'eth0').to_s)

    deep_merge(
      {
        enabled: true,
        managed: true,
        listen_on: 'https',
        vendor: 'isc',
        config: '/etc/dhcp/dhcpd.conf',
        leases: '/var/lib/dhcp/dhcpd.leases',
        interface: 'eth0',
        ip: net[:ip],
        subnet: net[:subnet],
        netmask: net[:netmask],
        range: [],
        broadcast: net[:broadcast],
        routers: Array(net[:router]).compact,
        options: [
          "domain-name \"#{new_resource.server_name}\"",
          "domain-name-servers #{net[:ip]}, 8.8.8.8",
        ],
        key_name: nil,
        key_secret: nil,
      },
      dhcp_overrides
    )
  end

  def merged_tftp
    deep_merge(
      {
        enabled: true,
        listen_on: 'https',
        root: '/var/lib/tftpboot',
        directories: %w(pxelinux.cfg boot),
        syslinux_filenames: [
          '/usr/lib/PXELINUX/pxelinux.0',
          '/usr/lib/syslinux/modules/bios/ldlinux.c32',
          '/usr/lib/syslinux/memdisk',
          '/usr/lib/syslinux/modules/bios/chain.c32',
          '/usr/lib/syslinux/modules/bios/menu.c32',
          '/usr/lib/syslinux/modules/bios/libutil.c32',
          '/usr/lib/syslinux/modules/bios/libcom32.c32',
        ],
        servername: nil,
        discovery_image_url: 'http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar',
      },
      symbolize_keys(new_resource.tftp)
    )
  end

  def merged_bmc
    deep_merge({ enabled: false, listen_on: 'https', default_provider: 'ipmitool' }, symbolize_keys(new_resource.bmc))
  end

  def merged_chef
    deep_merge(
      {
        enabled: true,
        listen_on: 'https',
        authenticate_nodes: true,
        server_url: 'https://chef.example.net',
        smartproxy_clientname: 'host.example.net',
        smartproxy_privatekey: '/etc/chef/client.pem',
        ssl_verify: true,
        ssl_pem_file: '/etc/chef/chef.example.com.pem',
      },
      symbolize_keys(new_resource.chef_module)
    )
  end

  def merged_puppet
    deep_merge(
      {
        enabled: false,
        listen_on: 'https',
        puppetdir: '/etc/puppet',
        ssldir: '/var/lib/puppet/ssl',
        puppet_url: "https://#{new_resource.server_name}:8140",
        provider: nil,
        customrun_cmd: '/bin/false',
        customrun_args: '',
        puppetssh_sudo: false,
        puppetssh_command: '/usr/bin/puppet agent --onetime --no-usecacheonfailure',
        puppetssh_wait: false,
        puppetssh_user: 'root',
        puppetssh_keyfile: '/etc/foreman-proxy/id_rsa',
        puppet_user: 'root',
        puppet_ssl_ca: '/etc/foreman/certs/ca.crt',
        puppet_ssl_cert: '/etc/foreman/certs/server.crt',
        puppet_ssl_key: '/etc/foreman/certs/server.key',
        puppet_use_environment_api: nil,
        puppet_use_cache: nil,
        puppet_cache_location: '/var/lib/smart-proxy/cache',
      },
      symbolize_keys(new_resource.puppet)
    )
  end

  def merged_puppetca
    deep_merge(
      {
        enabled: false,
        listen_on: 'https',
        ssldir: '/var/lib/puppet/ssl',
        puppetdir: '/etc/puppet',
      },
      symbolize_keys(new_resource.puppetca)
    )
  end

  def merged_realm
    deep_merge(
      {
        enabled: false,
        listen_on: 'https',
        provider: 'freeipa',
        keytab: '/etc/foreman-proxy/freeipa.keytab',
        principal: 'realm-proxy@EXAMPLE.COM',
        freeipa_remove_dns: true,
      },
      symbolize_keys(new_resource.realm)
    )
  end

  def merged_templates
    deep_merge(
      {
        enabled: false,
        listen_on: 'https',
        template_url: registered_proxy_url,
      },
      symbolize_keys(new_resource.templates_module)
    )
  end

  def foreman_base_url
    new_resource.foreman_base_url || "http#{'s' if new_resource.ssl_enabled}://#{new_resource.server_name}"
  end

  def registered_name
    new_resource.registered_name || node['fqdn'] || new_resource.server_name
  end

  def registered_proxy_url
    return new_resource.registered_proxy_url if present?(new_resource.registered_proxy_url)

    if new_resource.http_enabled
      "http://#{registered_name}:#{new_resource.http_port}"
    else
      "https://#{registered_name}:#{new_resource.https_port}"
    end
  end

  def oauth_consumer_key
    new_resource.oauth_consumer_key || cached_secret('proxy_oauth_consumer_key')
  end

  def oauth_consumer_secret
    new_resource.oauth_consumer_secret || cached_secret('proxy_oauth_consumer_secret')
  end

  def proxy_settings
    {
      settings_directory: "#{new_resource.config_path}/settings.d",
      ssl_enabled: new_resource.ssl_enabled,
      http_enabled: new_resource.http_enabled,
      ssl: merged_ssl,
      trusted_hosts: new_resource.trusted_hosts,
      foreman_url: foreman_base_url,
      daemon: new_resource.daemon,
      https_port: new_resource.https_port,
      http_port: new_resource.http_port,
      virsh_network: new_resource.virsh_network,
      log_file: new_resource.log_file,
      log_level: new_resource.log_level,
    }
  end

  def proxy_ssl_data_bag_item
    data_bag_item(new_resource.ssl_data_bag_name, new_resource.ssl_data_bag_item)
  rescue StandardError
    {}
  end

  def configure_managed_services
    if merged_tftp[:enabled]
      include_root_recipe('tftp')

      directory merged_tftp[:root] do
        owner new_resource.user
        group new_resource.group
        mode '0755'
      end

      merged_tftp[:directories].each do |directory_name|
        directory "#{merged_tftp[:root]}/#{directory_name}" do
          owner new_resource.user
          group new_resource.group
          mode '0775'
          recursive true
        end
      end

      package %w(pxelinux syslinux-common)

      Array(merged_tftp[:syslinux_filenames]).each do |syslinux_file|
        remote_file "#{merged_tftp[:root]}/#{::File.basename(syslinux_file)}" do
          source lazy { "file://#{syslinux_file}" }
          owner new_resource.user
          group new_resource.group
        end
      end

      execute 'download-and-extract-foreman-discovery-image' do
        command "wget -qO- '#{merged_tftp[:discovery_image_url]}' | tar -x -C #{merged_tftp[:root]}/boot/"
      end

      execute 'correct-foreman-discovery-image-ownership' do
        command "chown -R #{new_resource.user}:#{new_resource.group} #{merged_tftp[:root]}/boot/"
      end
    end

    if merged_dhcp[:enabled] && merged_dhcp[:managed]
      node.override['dhcp']['interfaces'] = [merged_dhcp[:interface]]
      node.override['dhcp']['parameters'] ||= {}
      node.override['dhcp']['parameters']['omapi-port'] = '7911'
      node.override['dhcp']['parameters']['next-server'] = merged_dhcp[:ip].to_s

      include_root_recipe('dhcp::server')

      dhcp_subnet 'foreman' do
        subnet merged_dhcp[:subnet]
        pool do
          range merged_dhcp[:range]
        end
        netmask merged_dhcp[:netmask]
        broadcast merged_dhcp[:broadcast]
        next_server merged_dhcp[:ip]
        routers merged_dhcp[:routers]
        options merged_dhcp[:options]
      end
    end

    if merged_dns[:enabled] && merged_dns[:managed]
      node.override['bind']['acl-role'] = 'external-acl'
      node.override['bind']['zonetype'] = 'master'
      node.override['bind']['masters'] = ['127.0.0.1']
      node.override['bind']['ipv6_listen'] = true
      node.override['bind']['options'] = [
        'check-names slave ignore;',
        'multi-master yes;',
        'provide-ixfr yes;',
        'request-ixfr yes;',
        'empty-zones-enable no;',
      ]
      node.override['bind']['zones'] ||= {}
      node.override['bind']['zones']['attribute'] = [new_resource.server_name]

      hostsfile_entry '127.0.0.1' do
        hostname new_resource.server_name
        action :append
      end

      include_root_recipe('bind')
    end
  end

  def write_proxy_ssl_files
    proxy_ssl = proxy_ssl_data_bag_item
    return unless proxy_ssl.key?('ssl_cert_key_file') && proxy_ssl.key?('ssl_cert_file') && proxy_ssl.key?('ssl_ca_file')

    {
      merged_ssl[:cert_key_file] => proxy_ssl['ssl_cert_key_file'],
      merged_ssl[:cert_file] => proxy_ssl['ssl_cert_file'],
      merged_ssl[:ca_file] => proxy_ssl['ssl_ca_file'],
    }.each do |path, content|
      file path do
        content content
        sensitive path.end_with?('.key')
      end
    end
  end
end

action :install do
  foreman_repo 'foreman-proxy-repository' do
    repo_uri new_resource.repo_uri
    repo_key new_resource.repo_key
    repo_release new_resource.repo_release
    repo_distribution new_resource.repo_distribution
    only_if { new_resource.use_repo }
  end

  package 'foreman-proxy' do
    version new_resource.version if present?(new_resource.version)
  end

  new_resource.plugins.each do |plugin_package|
    package plugin_package
  end

  package new_resource.api_package if new_resource.register

  package merged_bmc[:default_provider] do
    only_if { merged_bmc[:enabled] && merged_bmc[:default_provider] != 'shell' }
  end

  group new_resource.group do
    members new_resource.group_users
    append true
  end

  user new_resource.user do
    shell '/bin/bash'
    group new_resource.group
  end

  directory new_resource.config_path do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  directory "#{new_resource.config_path}/settings.d" do
    owner 'root'
    group new_resource.group
    mode '0755'
    recursive true
  end

  configure_managed_services

  group "#{new_resource.group}-dns-membership" do
    group_name new_resource.group
    members [merged_dns[:bind_user]]
    append true
    only_if { merged_dns[:enabled] && merged_dns[:managed] }
  end

  foreman_proxy_settings_file 'bmc' do
    action(merged_bmc[:enabled] ? :enable : :disable)
    listen_on merged_bmc[:listen_on]
    group new_resource.group
    config(merged_bmc.slice(:default_provider))
  end

  foreman_proxy_settings_file 'dhcp' do
    action(merged_dhcp[:enabled] ? :enable : :disable)
    listen_on merged_dhcp[:listen_on]
    group new_resource.group
    config(merged_dhcp.slice(:vendor, :config, :leases, :key_name, :key_secret))
  end

  foreman_proxy_settings_file 'dns' do
    action(merged_dns[:enabled] ? :enable : :disable)
    listen_on merged_dns[:listen_on]
    group new_resource.group
    config(merged_dns.slice(:provider, :server, :ttl, :tsig_keytab, :tsig_principal, :keyfile))
  end

  foreman_proxy_settings_file 'puppet' do
    action(merged_puppet[:enabled] ? :enable : :disable)
    listen_on merged_puppet[:listen_on]
    group new_resource.group
    config(merged_puppet)
  end

  foreman_proxy_settings_file 'puppetca' do
    action(merged_puppetca[:enabled] ? :enable : :disable)
    listen_on merged_puppetca[:listen_on]
    group new_resource.group
    config(merged_puppetca)
  end

  foreman_proxy_settings_file 'realm' do
    action(merged_realm[:enabled] ? :enable : :disable)
    listen_on merged_realm[:listen_on]
    group new_resource.group
    config(merged_realm.slice(:provider, :keytab, :principal, :freeipa_remove_dns))
  end

  foreman_proxy_settings_file 'tftp' do
    action(merged_tftp[:enabled] ? :enable : :disable)
    listen_on merged_tftp[:listen_on]
    group new_resource.group
    config(merged_tftp.slice(:root, :servername))
  end

  foreman_proxy_settings_file 'templates' do
    action(merged_templates[:enabled] ? :enable : :disable)
    listen_on merged_templates[:listen_on]
    group new_resource.group
    config(merged_templates.slice(:template_url))
  end

  foreman_proxy_settings_file 'chef' do
    action(merged_chef[:enabled] ? :enable : :disable)
    listen_on merged_chef[:listen_on]
    group new_resource.group
    config(merged_chef)
  end

  template "#{new_resource.config_path}/settings.yml" do
    source 'settings_foreman-proxy.yml.erb'
    cookbook 'foreman'
    group new_resource.group
    variables(proxy: proxy_settings)
  end

  write_proxy_ssl_files if new_resource.ssl_enabled

  service new_resource.service_name do
    action %i(enable start)
  end

  foreman_smartproxy registered_name do
    base_url foreman_base_url
    consumer_key oauth_consumer_key
    consumer_secret oauth_consumer_secret
    effective_user new_resource.oauth_effective_user
    url registered_proxy_url
    retries 3
    retry_delay 5
    only_if { new_resource.register }
  end
end
