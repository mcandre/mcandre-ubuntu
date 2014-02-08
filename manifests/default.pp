# Link bash profile

file { "/home/vagrant/.bash_profile":
  ensure => link,
  target => "/vagrant/.bash_profile"
}

# Update apt before installing any packages

class { "apt":
  update_timeout => 60
}

exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

# # Add PPAs

# apt::ppa { "ppa:hrzhu/smlnj-backport":
#   before => Package["smlnj"],
#   require => [File["/etc/apt/sources.list.d"], Exec["apt-update"]]
# }

# .bash_profile
# .clisprc.lisp

# Tons of programming languages

# package { [

  # # Bash 4.0

  # "build-essential",

  # "chicken-bin", "libchicken-dev", "libchicken6",

  # "clang",
  # "clisp",
  # "erlang",
  # "golang",
  # "haskell-platform",


  # # Java


  # "llvm",
  # "lua5.1",
  # "ocaml",
  # "r-base",
  # "gnu-smalltalk",
  # "smlnj",
  # "yasm",
  # "zsh"
  # ]:
#   ensure => latest
# }

# Scala
# Leiningen/Clojure

# Dev tools

package { "splint":
  ensure => latest
}

# Apache

# LaTeX

# Maven

# Quicklisp

# Erlang quickcheck

# NVM / Node ?

# coffee
# coffeelint
# stylus
# less
# mocha

# Ruby 2 / RubyGems ?

# Cucumber
# Guard
# rspec
# nokogiri
# specs
# rubycheck

# Python 3 / pip3

# CPAN, PPM
# yaml, Test, www::mechanize

# chicken-install cluckcheck

# vagrant, virtualbox

package { "git":
  ensure => latest
}

package { "vim":
  ensure => latest
}

# Link vim profile

file { "/home/vagrant/.vimrc":
  ensure => link,
  target => "/vagrant/.vimrc",
  require => Package["vim"]
}

file { "/home/vagrant/.vim/":
  ensure => directory,
  owner => "vagrant",
  group => "vagrant",
  require => Package["vim"]
}

exec { "git vundle":
  command => "/usr/bin/sudo -u vagrant git clone https://github.com/gmarik/vundle.git /home/vagrant/.vim/bundle/vundle",
  require => [
    Package["git"],
    Package["vim"],
    File["/home/vagrant/.vimrc"],
    File["/home/vagrant/.vim/"]
  ]
}

# Install Vim packages

exec { "vundle":
  command => "/usr/bin/sudo -u vagrant /usr/bin/vim +BundleInstall +qall",
  environment => "HOME=/home/vagrant/",
  require => Exec["git vundle"]
}

# .emacs
# .nano...
