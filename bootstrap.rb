#!/usr/bin/env ruby

modules_dir = '/etc/puppet/modules'

puts `mkdir -p #{modules_dir}` unless File::exists? modules_dir
  
mods = [
  "puppetlabs-stdlib",
  "puppetlabs/apt",
  "puppetlabs/vcsrepo",
  "example42/puppi",
  "example42/perl"
]

installed = `puppet module list`.split "\n"

mods.each do |mod|
  puts `puppet module install #{mod}` unless installed.any? { |i| i.include?(mod.sub('/','-')) }
end
