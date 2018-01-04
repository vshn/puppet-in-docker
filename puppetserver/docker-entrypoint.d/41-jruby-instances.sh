#!/bin/bash

echo "---> Configuring JRUBY instances of Puppetserver"
sed -i -E \
  "s/#?max-active-instances:.*/max-active-instances: ${PUPPETSERVER_JRUBYINSTANCES}/" \
  /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf
