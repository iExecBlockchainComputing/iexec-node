Vagrant.configure("2") do |config|
  config.vm.define "iexecdev" do |iexecdev|
    iexecdev.vm.box = "ubuntu/trusty64"
    # Change from "~/iexecdev" to an existing, and non-encrypted, folder on your host if the mount fails
    iexecdev.vm.synced_folder "~/iexecdev", "/home/vagrant/iexecdev", nfs: true, nfs_udp: false, create: true
    iexecdev.vm.network "private_network", type: "dhcp"
    iexecdev.vm.network :forwarded_port, guest: 8000, host: 8000
    iexecdev.vm.network :forwarded_port, guest: 3000, host: 3000
    iexecdev.vm.network :forwarded_port, guest: 8101, host: 8101
    iexecdev.vm.network :forwarded_port, guest: 8545, host: 8545


    iexecdev.vm.provider "virtualbox" do |v|
      host = RbConfig::CONFIG['host_os']
       v.memory = 3048
       v.cpus = 2
    end

    iexecdev.vm.provision "file", source: "dotscreenrc", destination: "~/.screenrc"
    iexecdev.vm.provision "file", source: "gethUtils", destination: "~/gethUtils"
    iexecdev.vm.provision :shell, path: "bootstrap.sh"


  end
end
