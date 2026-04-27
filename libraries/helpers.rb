# frozen_string_literal: true

require 'securerandom'
require 'yaml'

module ForemanCookbook
  module Helpers
    def cached_value(key)
      ::FileUtils.mkdir_p(cache_dir)
      cache_file = ::File.join(cache_dir, key)

      return YAML.safe_load(::File.read(cache_file)) if ::File.exist?(cache_file)

      value = block_given? ? yield : nil
      ::File.write(cache_file, YAML.dump(value))
      value
    end

    def cached_secret(key, length: 32)
      cached_value(key) { SecureRandom.alphanumeric(length) }
    end

    def cache_dir
      ::File.join(Chef::Config[:file_cache_path], 'foreman_cache_data')
    end

    def include_root_recipe(recipe_name)
      with_run_context :root do
        run_context.include_recipe(recipe_name)
      end
    end

    def deep_merge(base, overrides)
      base.merge(overrides) do |_key, old_value, new_value|
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          deep_merge(old_value, new_value)
        else
          new_value
        end
      end
    end

    def symbolize_keys(object)
      case object
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[key.respond_to?(:to_sym) ? key.to_sym : key] = symbolize_keys(value)
        end
      when Array
        object.map { |value| symbolize_keys(value) }
      else
        object
      end
    end

    def database_real_adapter(adapter)
      case adapter
      when 'sqlite'
        'sqlite3'
      when 'mysql'
        'mysql2'
      else
        adapter
      end
    end

    def present?(value)
      !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
    end

    def apt_distribution
      node.dig('lsb', 'codename') || node['platform']
    end
  end
end
