#!/usr/bin/env bash

# Disable jruby-puppet.use-legacy-auth-conf
# Suppresses the log message:
## WARN  [p.s.j.jruby-puppet-core] The jruby-puppet.use-legacy-auth-conf
## setting is set to 'true'. Support for the legacy Puppet auth.conf file
## is deprecated and will be removed in a future release.
## Change this setting to false and migrate your authorization rule 
## definitions in the /etc/puppetlabs/puppet/auth.conf file to the 
## /etc/puppetlabs/puppetserver/conf.d/auth.conf file.

echo "---> Disabling legacy auth"
sed -i 's/#use-legacy-auth-conf: false/use-legacy-auth-conf: false/' /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf

