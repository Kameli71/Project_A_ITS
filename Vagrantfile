# -*- mode: ruby -*-
# vi: set ft=ruby :
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up 
#   + On windows => $env:ENABLE_ZSH="true"
#   + On Linux  => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|
  config.vm.define "nginx" do |nginx|
    nginx.vm.disk :disk, size: "3G", name: "storage_bdd"
    nginx.vm.box = "geerlingguy/centos7"
    # nginx.vm.box_download_insecure=true 
    nginx.vm.network "private_network", type: "static", ip: "192.168.99.10"
    nginx.vm.hostname = "nginx"
    nginx.vm.provider "virtualbox" do |v|
      v.name = "nginx"
      v.memory = 2048
      v.cpus = 1
    end
    nginx.vm.provision :shell do |shell|
      shell.path = "scripts/installNginx.sh"
      shell.args = ["master", "192.168.99.10"] 
    end
    nginx.vm.provision :shell do |shell|
      shell.path = "scripts/installSSL1.sh"
      shell.args = ["master", "192.168.99.10"] 
    end
  end
  apps=2
  ram_app=2048
  cpu_app=2

    config.vm.define "app1" do |app|
      app.vm.box = "geerlingguy/centos7"
      app.vm.network "private_network", type: "static", ip: "192.168.99.11"
      app.vm.hostname = "app1"
      app.vm.provider "virtualbox" do |v|
        v.customize ['createhd', '--filename', 'app1-disk1.vmdk', '--size', "4124"]
        v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', "1", '--device', "0", '--type', 'hdd', '--medium', 'app1-disk1.vmdk']  
        v.name = "app1"
        v.memory = ram_app
        v.cpus = cpu_app
      end
      app.vm.provision :shell do |shell|
        shell.path = "scripts/install_joomla1.sh"
        shell.args = ["node", "192.168.99.10"]
      end
    end
    
config.vm.define "app2" do |app|
  app.vm.box = "geerlingguy/centos7"
  app.vm.network "private_network", type: "static", ip: "192.168.99.12"
  app.vm.hostname = "app2"
  app.vm.provider "virtualbox" do |v|
    v.customize ['createhd', '--filename', 'app2disk1.vmdk', '--size', "4124"]
    v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', "1", '--device', "0", '--type', 'hdd', '--medium', 'app2disk1.vmdk']
  v.name = "app2"
    v.memory = ram_app
    v.cpus = cpu_app
  end
  app.vm.provision :shell do |shell|
    shell.path = "install_joomla.sh"
    shell.args = ["node", "192.168.99.10"]
  end
end
end
