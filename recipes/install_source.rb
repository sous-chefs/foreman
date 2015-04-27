include_recipe 'git'

deploy_revision 'foreman' do
  deploy_to node['foreman']['path']
  repository node['foreman']['source']['repo']
  revision node['foreman']['source']['revision']
  symlinks('database.yml' => 'config/database.yml',
           'settings.yaml' => 'config/settings.yaml')
end

override['foreman']['current_path'] = ::File.join(node['foreman']['path'],
                                                  'current')
override['foreman']['config_path'] = ::File.join(node['foreman']['path'],
                                                 'shared')
