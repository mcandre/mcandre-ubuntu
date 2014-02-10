# Fix recursive globs
shopt -s globstar

# Cask
export PATH="$PATH:~/.cask/bin"

# Cabal
export PATH="$PATH:/root/.cabal/bin"

# Ruby
rvm use 2.1.0 > /dev/null

cd /vagrant/
