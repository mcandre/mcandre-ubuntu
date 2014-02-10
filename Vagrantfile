VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.provision :shell, path: 'upgrade-puppet.sh'

  # Install puppet modules
  config.vm.provision :shell, path: 'bootstrap.rb', args: "puppetlabs-stdlib \
    puppetlabs/apt \
    puppetlabs/vcsrepo \
    example42/puppi \
    example42/perl \
    example42/mongodb \
    stankevich/python \
    maestrodev/rvm"

  config.vm.provision :puppet
end
