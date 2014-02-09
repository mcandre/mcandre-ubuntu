# Update apt before installing any packages

class { 'apt':
  update_timeout => 60
}

exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Package <| |>

apt::ppa { 'ppa:cassou/emacs': }

package { 'emacs24':
  ensure => latest,
  require => Apt::Ppa['ppa:cassou/emacs']
}

package { 'git':
  ensure => latest
}

package { 'vim':
  ensure => latest
}

# Link vim profile

file { '/home/vagrant/.vimrc':
  ensure => link,
  target => '/vagrant/.vimrc',
  owner  => 'vagrant',
  group  => 'vagrant'
}

file { '/home/vagrant/.vim/':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}

vcsrepo { '/home/vagrant/.vim/bundle/vundle':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/gmarik/vundle',
  owner    => 'vagrant',
  group    => 'vagrant'
}

# Install Vim packages

exec { 'vundle':
  command     => 'vim +BundleInstall +qall',
  path        => '/usr/bin',
  user        => 'vagrant',
  environment => 'HOME=/home/vagrant/',
  refreshonly => true,
  require     => [
    Package['vim'],
    Vcsrepo['/home/vagrant/.vim/bundle/vundle']
  ],
  subscribe   => File['/home/vagrant/.vimrc']
}

# Fix Emacs permissions

file { '/home/vagrant/.emacs.d/':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant'
}

vcsrepo { '/home/vagrant/.cask':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/cask/cask',
  owner    => 'vagrant',
  group    => 'vagrant'
}

# Link Cask profile

file { '/home/vagrant/.emacs.d/Cask':
  ensure  => link,
  target  => '/vagrant/Cask',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => File['/home/vagrant/.emacs.d/']
}

# Link emacs profile

file { '/home/vagrant/.emacs':
  ensure => link,
  target => '/vagrant/.emacs',
  owner  => 'vagrant',
  group  => 'vagrant',
}

# Install Emacs packages

exec { 'cask':
  command     => 'emacs -q --batch --eval \"(progn \
    (require \'cask \\\"~/.cask/cask.el\\\") \
    (cask-initialize) (setq save-abbrevs nil) \
    (cask-install) \
    (kill-emacs))\"',
  path        => '/usr/bin',
  user        => 'vagrant',
  environment => 'HOME=/home/vagrant/',
  refreshonly => true,
  require     => [
    Package['emacs24'],
    Vcsrepo['/home/vagrant/.cask']
  ],
  subscribe   => File['/home/vagrant/.emacs.d/Cask'],
}

# Link nano profile

file { '/home/vagrant/.nanorc':
  ensure => link,
  target => '/vagrant/.nanorc',
  owner  => 'vagrant',
  group  => 'vagrant'
}

# Install Nano packages

vcsrepo { '/home/vagrant/.nano':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/serialhex/nano-highlight',
  owner    => 'vagrant',
  group    => 'vagrant'
}

package { 'curl':
  ensure => latest
}

apt::ppa { 'ppa:hrzhu/smlnj-backport': }

package { 'smlnj':
  ensure => latest,
  require => Apt::Ppa['ppa:hrzhu/smlnj-backport']
}

# gcc, g++, make, etc.

package { 'build-essential':
  ensure => latest
}

package { 'strace':
  ensure => latest
}

package { 'splint':
  ensure => latest
}

package { 'cppcheck':
  ensure => latest
}

package { 'clang':
  ensure => latest
}

# Chicken Scheme

package { 'chicken-bin':
  ensure => latest
}

exec { 'chicken cluckcheck':
  command => 'chicken-install cluckcheck',
  path    => '/usr/bin',
  require => Package['chicken-bin'],
  onlyif  => '/usr/bin/test ! -f /var/lib/chicken/6/cluckcheck.o',
  logoutput => true
}

package { 'erlang':
  ensure => latest
}

package { 'golang':
  ensure => latest
}

package { 'haskell-platform':
  ensure => latest
}

exec { 'cabal update':
  command   => 'cabal update',
  path      => '/usr/bin',
  require   => Package['haskell-platform'],
  logoutput => true
}

exec { 'cabal hlint':
  command   => 'cabal -v3 install hlint',
  path      => '/usr/bin',
  require   => Exec['cabal update'],
  onlyif    => '/usr/bin/test ! -d /home/root/.cabal/packages/hackage.haskell.org/hlint',
  logoutput => true,
}

# exec { 'cabal shellcheck':
#   command   => 'cabal -v3 install shellcheck',
#   user      => 'vagrant',
#   path      => '/usr/sbin',
# # environment => 'HOME=/home/vagrant/',
#   require   => Exec['cabal update'],
#   onlyif    => '/usr/bin/test ! -d /home/vagrant/.cabal/packages/hackage.haskell.org/shellcheck',
#   logoutput => true,
# }

# xmllint from libxml2...

# llvm-as, etc.

package { 'llvm':
  ensure => latest
}

package { 'lua5.1':
  ensure => latest
}

package { 'ocaml':
  ensure => latest
}

package { 'r-base':
  ensure => latest
}

package { 'gnu-smalltalk':
  ensure => latest
}

package { 'yasm':
  ensure => latest
}

package { 'zsh':
  ensure => latest
}

# Empty zsh profile

file { '/home/vagrant/.zshrc':
  ensure => present,
  owner  => 'vagrant',
  group  => 'vagrant'
}

package { 'tree':
  ensure => latest
}

# pip for Python 2

package { 'python-pip':
  ensure => latest
}

# Invoke
# PyLint
# PyFlakes
# pep8
# PyChecker

package { ['vagrant', 'virtualbox']:
  ensure => latest
}

class { 'perl': }

perl::cpan::module { 'WWW::Mechanize': }

perl::cpan::module { 'App::Ack': }

# Link to ack profile

file { '/home/vagrant/.ackrc':
  ensure => link,
  target => '/vagrant/.ackrc',
  owner  => 'vagrant',
  group  => 'vagrant'
}

# 'clisp'
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

# Bash 4.0...

# Link bash profile

file { '/home/vagrant/.bash_profile':
  ensure => link,
  target => '/vagrant/.bash_profile',
  owner  => 'vagrant',
  group  => 'vagrant'
}
