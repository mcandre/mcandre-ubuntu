VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.provision :shell do |shell|
    shell.inline = "mkdir -p /etc/puppet/modules;
                    puppet module install -f puppetlabs-stdlib;
                    puppet module install -f puppetlabs/apt;
                    puppet module install -f example42/puppi;
                    puppet module install -f example42/perl"
  end

  config.vm.provision :puppet do |puppet|
    # puppet.options = "--verbose --debug"
  end
end
