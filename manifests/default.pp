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

apt::ppa { "ppa:cassou/emacs":
  before => Package["emacs24"]
}

package { "emacs24":
  ensure => latest
}

# .clisprc.lisp

# package { [

  # # Bash 4.0

  # "clisp",

  # # Java

  # ]:
#   ensure => latest
# }

# Scala
# Leiningen/Clojure

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
# sass
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
  target => "/vagrant/.vimrc"
}

file { "/home/vagrant/.vim/":
  ensure => directory,
  owner => "vagrant",
  group => "vagrant",
}

exec { "git vundle":
  command => "/usr/bin/sudo -u vagrant git clone https://github.com/gmarik/vundle.git /home/vagrant/.vim/bundle/vundle",
  require => [
    Package["git"],
    File["/home/vagrant/.vim/"]
  ],
  onlyif => "/usr/bin/test ! -d /home/vagrant/.vim/bundle/vundle/"
}

# Install Vim packages

exec { "vundle":
  command => "/usr/bin/sudo -u vagrant /usr/bin/vim +BundleInstall +qall",
  environment => "HOME=/home/vagrant/",
  refreshonly => true,
  require => [
    Package["vim"],
    Exec["git vundle"]
  ],
  subscribe => File["/home/vagrant/.vimrc"]
}

# Fix Emacs permissions

file { "/home/vagrant/.emacs.d/":
  ensure => directory,
  owner => "vagrant",
  group => "vagrant"
}

exec { "git cask":
  command => "/usr/bin/sudo -u vagrant git clone https://github.com/cask/cask.git /home/vagrant/.cask",
  require => Package["git"],
  onlyif => "/usr/bin/test ! -d /home/vagrant/.cask/"
}

# Link Cask profile

file { "/home/vagrant/.emacs.d/Cask":
  ensure => link,
  target => "/vagrant/Cask",
  require => File["/home/vagrant/.emacs.d/"]
}

# Link emacs profile

file { "/home/vagrant/.emacs":
  ensure => link,
  target => "/vagrant/.emacs"
}

# Install Emacs packages

exec { "cask":
  command => "/usr/bin/sudo -u vagrant /usr/bin/emacs -q --batch --eval \"(progn (require 'cask \\\"~/.cask/cask.el\\\") (cask-initialize) (setq save-abbrevs nil) (cask-install) (kill-emacs))\"",
  environment => "HOME=/home/vagrant/",
  refreshonly => true,
  require => [
    Package["emacs24"],
    Exec["git cask"]
  ],
  subscribe => File["/home/vagrant/.emacs.d/Cask"],
}

# Link nano profile

file { "/home/vagrant/.nanorc":
  ensure => link,
  target => "/vagrant/.nanorc"
}

# Install Nano packages

exec { "git nano":
  command => "/usr/bin/sudo -u vagrant /usr/bin/git clone https://github.com/serialhex/nano-highlight.git ~/.nano",
  environment => "HOME=/home/vagrant/",
  require => Package["git"],
  onlyif => "/usr/bin/test ! -d /home/vagrant/.nano/"
}

package { "curl":
  ensure => latest
}

apt::ppa { "ppa:hrzhu/smlnj-backport":
  before => Package["smlnj"]
}

package { "smlnj":
  ensure => latest
}

# gcc, g++, make, etc.

package { "build-essential":
  ensure => latest
}

package { "clang":
  ensure => latest
}

# Chicken Scheme

package { "chicken-bin":
  ensure => latest
}

package { "erlang":
  ensure => latest
}

package { "golang":
  ensure => latest
}

package { "haskell-platform":
  ensure => latest
}

# llvm-as, etc.

package { "llvm":
  ensure => latest
}

package { "lua5.1":
  ensure => latest
}

package { "ocaml":
  ensure => latest
}

package { "r-base":
  ensure => latest
}

package { "gnu-smalltalk":
  ensure => latest
}

package { "yasm":
  ensure => latest
}

package { "zsh":
  ensure => latest
}

# Empty zsh profile

file { "/home/vagrant/.zshrc":
  ensure => present
}

package { "tree":
  ensure => latest
}

package { "splint":
  ensure => latest
}
