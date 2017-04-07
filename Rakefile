# -*- coding: utf-8 -*-
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def run_command(command)
  if File.exist?('Gemfile.lock')
    sh %(bundle exec #{command})
  else
    sh %(chef exec #{command})
  end
end

task :vendor do
  sh 'rm -rf cookbooks; rm -f Berksfile.lock'
  run_command 'berks vendor cookbooks'
end

namespace :example do
  task :destroy do
    run_command('chef-client -z example/vagrant_linux.rb example/destroy.rb')
  end

  task :deploy do
    Rake::Task['vendor'].invoke
    run_command('chef-client -z example/vagrant_linux.rb example/deploy.rb')
  end
end

namespace :test do
  desc 'Tests suites runner'

  task :checkstyle do
    Rake::Task['test:foodcritic'].invoke
    Rake::Task['test:rubocop'].invoke
  end

  task :specs do
    Rake::Task['test:chefspec'].invoke
  end

  task :foodcritic do
    run_command 'foodcritic -f any .'
  end

  task :rubocop do
    run_command :rubocop
  end

  task :chefspec do
    run_command 'rspec spec'
  end

  task :kitchen do
    run_command 'kitchen test'
  end
end

task default: ['test:checkstyle', 'test:specs']
