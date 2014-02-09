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

apt::ppa { "ppa:cassou/emacs": }

package { "emacs24":
  ensure => latest
}

# Bash 4.0

# "clisp"
# Quicklisp
# .clisprc.lisp

# Java
# Scala
# Leiningen/Clojure
# Maven
# Checkstyle

# Apache

# LaTeX

# NVM / Node ?
# coffee
# coffeelint
# stylus
# less
# csslint
# tidy
# sass
# sasslint
# mocha

# Ruby 2 / RubyGems ?
# Cucumber
# Guard
# rspec
# nokogiri
# specs
# rubycheck
# puppet-lint
# reek
# flay
# roodi
# cane
# excellent
# rubycop
# heckle
# saikuro
# flog
# churn
# shlint

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

apt::ppa { "ppa:hrzhu/smlnj-backport": }

package { "smlnj":
  ensure => latest
}

# gcc, g++, make, etc.

package { "build-essential":
  ensure => latest
}

package { "strace":
  ensure => latest
}

package { "splint":
  ensure => latest
}

package { "cppcheck":
  ensure => latest
}

package { "clang":
  ensure => latest
}

# Chicken Scheme

package { "chicken-bin":
  ensure => latest
}

exec { "chicken cluckcheck":
  command => "/usr/bin/chicken-install cluckcheck",
  environment => "HOME=/home/vagrant/",
  require => Package["chicken-bin"],
  onlyif => "/usr/bin/test ! -f /var/lib/chicken/6/cluckcheck.o"
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

# exec { "cabal update":
#   command => "/usr/bin/sudo -u vagrant cabal update",
#   environment => "HOME=/home/vagrant/",
# }

# exec { "cabal hlint":
#   command => "/usr/bin/sudo -u vagrant /usr/bin/cabal -v3 install hlint 2>&1",
#   environment => "HOME=/home/vagrant/",
#   require => Exec["cabal update"],
#   onlyif => "test ! -d /home/vagrant/.cabal/packages/hackage.haskell.org/hlint/"
#   logoutput => true,
# }

# shellcheck...

# xmllint from libxml2...

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

# pip for Python 2

package { "python-pip":
  ensure => latest
}

# Invoke
# PyLint
# PyFlakes
# pep8
# PyChecker

package { ["vagrant", "virtualbox"]:
  ensure => latest
}

class { "perl": }

perl::cpan::module { "WWW::Mechanize": }

perl::cpan::module { "App::Ack": }

# Link to ack profile

file { "/home/vagrant/.ackrc":
  ensure => link,
  target => "/vagrant/.ackrc"
}
