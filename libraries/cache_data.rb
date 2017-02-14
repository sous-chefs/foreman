require 'yaml'

module Foreman
  def cache_data(key, data)
    cache_dir = File.join(Chef::Config[:file_cache_path], 'foreman_cache_data')
    cache_file = File.join(cache_dir, key)
    if File.exist?(cache_file)
      YAML.safe_load(File.read(cache_file))
    else
      FileUtils.mkdir_p(cache_dir) unless File.exist?(cache_dir)
      File.write(cache_file, YAML.dump(data))

      data
    end
  end
end
