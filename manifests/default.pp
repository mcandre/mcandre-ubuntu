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

# Add PPAs

apt::ppa { "ppa:cassou/emacs":
  before => Package["emacs24"]
}

package { "emacs24":
  ensure => latest
}

# Tons of programming languages

# apt::ppa { "ppa:hrzhu/smlnj-backport":
#   before => Package["smlnj"]
# }

# package { "smlnj":
#   ensure => latest
# }

# .clisprc.lisp

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
  # "yasm",
  # "zsh"
  # ]:
#   ensure => latest
# }

# Scala
# Leiningen/Clojure

# Dev tools

package { "tree":
  ensure => latest
}

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

# ack

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
  refreshonly => true,
  require => [
    Package["git"],
    Package["vim"],
    File["/home/vagrant/.vim/"]
  ],
  onlyif => "/usr/bin/test -d /home/vagrant/.vim/bundle/vundle"
}

# Install Vim packages

exec { "vundle":
  command => "/usr/bin/sudo -u vagrant /usr/bin/vim +BundleInstall +qall",
  environment => "HOME=/home/vagrant/",
  refreshonly => true,
  require => Exec["git vundle"],
  subscribe => File["/home/vagrant/.vimrc"]
}

# .emacs
# .nano...
