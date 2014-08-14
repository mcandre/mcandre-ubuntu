VAGRANTFILE_API_VERSION = '2'

if !Vagrant.has_plugin?('vagrant-vbguest')
  puts 'The vagrant-vbguest plugin is encouraged for this machine. Install with:'
  puts '    $ vagrant plugin install vagrant-vbguest'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048 # MB
  end

  config.vm.provision :shell, path: 'upgrade-puppet.sh'

  # Install puppet modules
  config.vm.provision :shell, path: 'bootstrap.rb', args: %w(
    puppetlabs-stdlib
    puppetlabs/apt
    puppetlabs/vcsrepo
    example42/puppi
    example42/perl
    example42/mongodb
    stankevich/python
    maestrodev/rvm
    willdurand/nodejs
  )

  config.vm.provision :puppet do |puppet|
    puppet.options = ENV['PUPPET_OPTIONS']
  end
end
