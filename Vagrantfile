VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  # Install puppet modules
  config.vm.provision :shell, path: 'bootstrap.sh'

  config.vm.provision :puppet do |puppet|
    puppet.options = '--verbose --debug'
  end
end
