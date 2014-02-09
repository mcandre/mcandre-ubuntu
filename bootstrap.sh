#!/bin/bash

if [ ! -d /etc/puppet/modules ]; then
  mkdir -p /etc/puppet/modules
fi

MODULES=(puppetlabs-stdlib puppetlabs/apt puppetlabs/vcsrepo example42/puppi example42/perl)

INSTALLED=`puppet module list`

for MODULE in $MODULES; do
  if [[ ! ${INSTALLED[*]} =~ $MODULE ]]; then
    puppet module install $MODULE
  fi
done
