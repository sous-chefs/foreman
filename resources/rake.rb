# -*- coding: utf-8 -*-
#
# Cookbook:: foreman
# Resource:: rake
#
actions :run
default_action :run

attribute :rake_task, kind_of: String, name_attribute: true
attribute :environment, kind_of: Hash, default: {}
attribute :timeout, kind_of: Integer, default: nil
