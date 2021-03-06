# -*- mode: ruby -*-
# vi: set ft=ruby : 

# Vagrantfile API/syntax version.  Don't touch unless you know what you're doing! 
VAGRANTFILE_API_VERSION = "2" 

# Sets vmware fusion as the default provider 
VAGRANT_DEFAULT_PROVIDER = "vmware_fusion" 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config| 

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/centos-6.5" 

  # Forward default rails development server port
  config.vm.network :forwarded_port, guest: 3000, host: 3001, auto_correct: true

  # Forward local fedora/solr instances on this port
  config.vm.network :forwarded_port, guest: 8983, host: 8984, auto_correct: true

  # If true, then any SSH connections made will enable agent forward.
  # Default value: false
  config.ssh.forward_agent = true 

  # Optimizations for vmware_fusion machines
  config.vm.provider "vmware_fusion" do |vm|
    vm.customize ['modifyvm', :id, '--memory', '3072', '--cpus', '4', '--natdnsproxy1', 'off', '--natdnshostresolver1', 'off', '--ioapic', 'on']
    vm.vmx["memsize"] = "3072"
    vm.vmx["numvcpus"] = "4"
  end

  # Some optimization configurations kept in if someone needs to run Virtualbox
  # TODO: Figure out which of these are worth carrying over to the vmware config
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", '5734']
    vb.customize ["modifyvm", :id, "--ioapic", 'on']
    vb.customize ["modifyvm", :id, "--cpus", '4']
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  # Runs configuration required to get the dummy application up and going so that 
  # we can test what we're doing. 
  config.vm.provision "shell", path: "provisioning.sh", privileged: false

  config.vm.synced_folder ".", "/vagrant", :type => "nfs"

  config.vm.network "private_network", ip: "192.168.3.3"
end
