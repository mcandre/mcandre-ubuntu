# Update apt before installing any packages

class { 'apt':
  update_timeout => 60
}

exec { 'apt-update':
  command     => 'apt-get update',
  path        => '/bin:/usr/bin',
  timeout     => 0
}

Exec['apt-update'] -> Package <| |>

apt::ppa { 'ppa:cassou/emacs': }

package { 'emacs24':
  ensure  => present,
  require => Apt::Ppa['ppa:cassou/emacs']
}

package { 'vim':
  ensure => present
}

# Vim profile

file { '/home/vagrant/src':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant'
}

# Profiles

vcsrepo { '/home/vagrant/src/dotfiles':
  ensure   => latest,
  provider => git,
  source   => 'https://github.com/mcandre/dotfiles',
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => File['/home/vagrant/src']
}

# Vim profile

file { '/home/vagrant/.vimrc':
  ensure  => link,
  target  => '/home/vagrant/src/dotfiles/.vimrc',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => Vcsrepo['/home/vagrant/src/dotfiles']
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
  path        => '/bin:/usr/bin',
  user        => 'vagrant',
  environment => 'HOME=/home/vagrant/',
  refreshonly => true,
  require     => [
    Package['vim'],
    Vcsrepo['/home/vagrant/.vim/bundle/vundle'],
    File['/home/vagrant/.vimrc']
  ],
  subscribe   => Vcsrepo['/home/vagrant/src/dotfiles']
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

# Cask profile

file { '/home/vagrant/.emacs.d/Cask':
  ensure  => link,
  target  => '/home/vagrant/src/dotfiles/Cask',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => [
    File['/home/vagrant/.emacs.d/'],
    Vcsrepo['/home/vagrant/src/dotfiles']
  ]
}

# Emacs profile

file { '/home/vagrant/.emacs':
  ensure  => link,
  target  => '/home/vagrant/src/dotfiles/.emacs',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => Vcsrepo['/home/vagrant/src/dotfiles']
}

# Install Emacs packages

exec { 'cask':
  command     => "emacs -q --batch --eval \"(progn \
    (require 'cask \\\"~/.cask/cask.el\\\")
    (cask-initialize)
    (setq save-abbrevs nil)
    (cask-install)
    (kill-emacs))\"",
  path        => '/bin:/usr/bin',
  user        => 'vagrant',
  environment => 'HOME=/home/vagrant/',
  refreshonly => true,
  require     => [
    Package['emacs24'],
    Vcsrepo['/home/vagrant/.cask'],
    File['/home/vagrant/.emacs.d/Cask']
  ],
  subscribe   => Vcsrepo['/home/vagrant/src/dotfiles']
}

# Nano profile

file { '/home/vagrant/.nanorc':
  ensure  => link,
  target  => '/home/vagrant/src/dotfiles/.nanorc',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => Vcsrepo['/home/vagrant/src/dotfiles']
}

# Install Nano packages

vcsrepo { '/home/vagrant/.nano':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/serialhex/nano-highlight',
  owner    => 'vagrant',
  group    => 'vagrant'
}

apt::ppa { 'ppa:hrzhu/smlnj-backport': }

package { 'smlnj':
  ensure  => present,
  require => Apt::Ppa['ppa:hrzhu/smlnj-backport']
}

# gcc, g++, make, etc.

package { 'build-essential':
  ensure => present
}

package { 'strace':
  ensure => present
}

package { 'splint':
  ensure => present
}

package { 'cppcheck':
  ensure => present
}

package { 'valgrind':
  ensure => present
}

# Boehmgc

package { 'libgc-dev':
  ensure => present
}

package { 'clang':
  ensure => present
}

package { 'tidy':
  ensure => present
}

# Chicken Scheme

package { 'chicken-bin':
  ensure => present
}

exec { 'chicken cluckcheck':
  command => 'chicken-install cluckcheck',
  path    => '/bin:/usr/bin',
  require => Package['chicken-bin'],
  onlyif  => '/usr/bin/test ! -f /var/lib/chicken/6/cluckcheck.o'
}

package { 'erlang':
  ensure => present
}

package { 'golang':
  ensure => present
}

package { 'haskell-platform':
  ensure => present
}

exec { 'cabal update':
  command     => 'cabal update',
  environment => 'HOME=/root',
  path        => '/bin:/usr/bin',
  require     => Package['haskell-platform']
}

# Fix cabal permissions

file { ['/root', '/root/.cabal']:
  ensure  => directory,
  mode    => '0644',
}

file { '/root/.cabal/bin':
  ensure  => directory,
  mode    => '0777',
  recurse => true
}

exec { 'cabal hlint':
  command     => 'cabal install hlint',
  path        => '/bin:/usr/bin',
  environment => 'HOME=/root',
  timeout     => 0,
  require     => Exec['cabal update'],
  onlyif      => '/usr/bin/test ! -d \
    /root/.cabal/packages/hackage.haskell.org/hlint',
}

exec { 'cabal shellcheck':
  command     => 'cabal install shellcheck',
  path        => '/bin:/usr/bin',
  environment => 'HOME=/root',
  timeout     => 0,
  require     => Exec['cabal update'],
  onlyif      => '/usr/bin/test ! -d \
    /root/.cabal/packages/hackage.haskell.org/ShellCheck',
}

# llvm-as, etc.

package { 'llvm':
  ensure => present
}

package { 'lua5.1':
  ensure => present
}

package { 'ocaml':
  ensure => present
}

package { 'r-base':
  ensure => present
}

package { 'gnu-smalltalk':
  ensure => present
}

package { 'yasm':
  ensure => present
}

package { 'zsh':
  ensure => present
}

# Empty zsh profile

file { '/home/vagrant/.zshrc':
  ensure => present,
  owner  => 'vagrant',
  group  => 'vagrant'
}

package { 'tree':
  ensure => present
}

# Python 2 and pip 2

class { 'python':
  version    => 'system',
  virtualenv => true,
  pip        => true
}

python::pip { 'invoke':
  ensure => present,
  owner  => 'root'
}

python::pip { 'pylint':
  ensure => present,
  owner  => 'root'
}

python::pip { 'pyflakes':
  ensure => present,
  owner  => 'root'
}

python::pip { 'pep8':
  ensure => present,
  owner  => 'root'
}

package { ['vagrant', 'virtualbox']:
  ensure => present
}

class { 'perl': }

perl::cpan::module { 'App::Ack':
  require => Package['build-essential']
}

perl::cpan::module { 'Test::More': }

perl::cpan::module { 'Perl::Critic': }

# perl::cpan::module { 'PAR::Packer':
#   require => Package['build-essential']
# }

perl::cpan::module { 'WWW::Mechanize': }

# Ack profile

file { '/home/vagrant/.ackrc':
  ensure  => link,
  target  => '/home/vagrant/dotfiles/.ackrc',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => Vcsrepo['/home/vagrant/src/dotfiles']
}

class { 'nodejs':
  version => 'v0.10.25'
}

package { 'coffee-script':
  provider => npm
}

package { 'coffeelint':
  provider => npm
}

package { 'stylus':
  provider => npm
}

package { 'less':
  provider => npm
}

package { 'csslint':
  provider => npm
}

package { 'sass':
  provider => npm
}

package { 'mocha':
  provider => npm
}

package { 'jshint':
  provider => npm
}

class { 'rvm':
  version => '1.25.17'
}

rvm::system_user { 'vagrant': ; }

rvm_system_ruby {
  'ruby-2.1.0':
    ensure      => present,
    default_use => false;
}

rvm_gem {
  'bundler':
    ensure       => present,
    name         => 'bundler',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'cucumber':
    ensure       => present,
    name         => 'cucumber',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'rspec':
    ensure       => present,
    name         => 'rspec',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'guard':
    ensure       => present,
    name         => 'guard',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'specs':
    ensure       => present,
    name         => 'specs',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'puppet-lint':
    ensure       => present,
    name         => 'puppet-lint',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'reek':
    ensure       => present,
    name         => 'reek',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'flay':
    ensure       => present,
    name         => 'flay',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'roodi':
    ensure       => present,
    name         => 'roodi',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'cane':
    ensure       => present,
    name         => 'cane',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'excellent':
    ensure       => present,
    name         => 'excellent',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'rubocop':
    ensure       => present,
    name         => 'rubocop',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'flog':
    ensure       => present,
    name         => 'flog',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'tailor':
    ensure       => present,
    name         => 'tailor',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'churn':
    ensure       => present,
    name         => 'churn',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'shlint':
    ensure       => present,
    name         => 'shlint',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

rvm_gem {
  'sasslint':
    ensure       => present,
    name         => 'sasslint',
    ruby_version => 'ruby-2.1.0',
    require      => Rvm_system_ruby['ruby-2.1.0'];
}

package { 'clisp':
  ensure => present
}

# CLISP profile

file { '/home/vagrant/.clisprc.lisp':
  ensure  => link,
  target  => '/home/vagrant/src/dotfiles/.clisprc.lisp',
  owner   => 'vagrant',
  group   => 'vagrant',
  require => Vcsrepo['/home/vagrant/src/dotfiles']
}

exec { '/home/vagrant/quicklisp.lisp':
  command => 'wget http://beta.quicklisp.org/quicklisp.lisp',
  path    => '/usr/bin',
  user    => 'vagrant',
  cwd     => '/home/vagrant',
  onlyif  => '/usr/bin/test ! -f /home/vagrant/quicklisp.lisp'
}

file { '/home/vagrant/install-quicklisp.lisp':
  ensure => link,
  target => '/vagrant/install-quicklisp.lisp',
  owner  => 'vagrant',
  group  => 'vagrant'
}

exec { 'clisp quicklisp':
  command     => 'clisp install-quicklisp.lisp',
  path        => '/usr/bin',
  user        => 'vagrant',
  cwd         => '/home/vagrant',
  environment => 'HOME=/home/vagrant',
  require     => [
    Package['clisp'],
    File['/home/vagrant/.clisprc.lisp'],
    File['/home/vagrant/install-quicklisp.lisp'],
    Exec['/home/vagrant/quicklisp.lisp']
  ],
  onlyif      => '/usr/bin/test ! -d /home/vagrant/quicklisp'
}

exec { 'cl-quickcheck':
  command     => 'clisp -x "(ql:quickload \'cl-quickcheck)"',
  path        => '/usr/bin',
  user        => 'vagrant',
  environment => 'HOME=/home/vagrant',
  require     => Exec['clisp quicklisp'],
  onlyif      => '/usr/bin/test ! -d \
    /home/vagrant/quicklisp/dists/quicklisp/software/cl-quickcheck-*-git'
}

package { 'openjdk-7-jdk':
  ensure => present
}

package { 'maven':
  ensure => present
}

package { 'scala':
  ensure => present
}

package { ['leiningen', 'clojure1.2']:
  ensure => present
}

package { 'checkstyle':
  ensure => present
}

# Link bash profile

file { '/home/vagrant/.bash_profile':
  ensure => link,
  target => '/vagrant/.bash_profile',
  owner  => 'vagrant',
  group  => 'vagrant'
}

package { 'apache2':
  ensure => present
}

package { ['php5', 'libapache2-mod-php5']:
  ensure => present
}

package { ['mysql-server', 'mysql-client']:
  ensure => present
}

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => present
}

package { 'redis-server':
  ensure => present
}

class { 'mongodb': }

package { 'texlive':
  ensure => present
}

package { 'curl':
  ensure => present
}

package { 'git':
  ensure => present
}

# xmllint

package { 'libxml2-utils':
  ensure => present
}
