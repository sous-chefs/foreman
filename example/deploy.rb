require 'chef/provisioning'

controller_config = <<-ENDCONFIG
config.vm.provider "virtualbox" do |v|
v.memory = 4096
v.cpus = 2
v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
end
config.vm.network "private_network", ip: "172.16.0.10"
ENDCONFIG

machine 'foreman' do
  add_machine_options vagrant_config: controller_config
  recipe 'apt'
  recipe 'foreman'
  chef_environment '_default'
  converge true
end
