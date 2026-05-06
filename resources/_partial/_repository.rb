# frozen_string_literal: true

property :use_repo, [true, false], default: true
property :repo_uri, String, default: 'http://deb.theforeman.org/'
property :repo_key, String, default: 'https://deb.theforeman.org/foreman.asc'
property :repo_release, String, default: '3.18'
property :repo_distribution, String, default: lazy { node.dig('lsb', 'codename') || node['platform'] }
