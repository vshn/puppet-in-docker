#!/bin/bash

CA_SERVER=${CA_SERVER:-puppetca.local}
MCOLLECTIVE_CERTNAME=${MCOLLECTIVE_CERTNAME:-deployer.mcollective}
NATS=${NATS:-nats.local:4222}
PUPPETDB=${PUPPETDB:-puppetdb.local}
PUPPETSERVER=${PUPPETSERVER:-puppetserver.local}

if [ "${SKIP_CERT_CONFIG}" == "true" ]; then
  echo "---> Skipping certificate configuration"
else
  echo "---> Preparing SSL directories for MCO client"
  mkdir -p /home/deployer/.puppetlabs/etc/puppet/ssl/private_keys
  mkdir -p /home/deployer/.puppetlabs/etc/puppet/ssl/certs

  # Key and certificates must be set in environment, otherwise it doesn't work
  if [ -n "${PRIVATE_KEY}" ]; then
    echo "---> Configuring Client: PRIVATE_KEY"
    echo "${PRIVATE_KEY}" > /home/deployer/.puppetlabs/etc/puppet/ssl/private_keys/${MCOLLECTIVE_CERTNAME}.pem
  else
    echo "---> Fatal! PRIVATE_KEY not set. Exiting"
    exit 1
  fi
  if [ -n "${CERTIFICATE}" ]; then
    echo "---> Configuring Client: CERTIFICATE"
    echo "${CERTIFICATE}" > /home/deployer/.puppetlabs/etc/puppet/ssl/certs/${MCOLLECTIVE_CERTNAME}.pem
  else
    echo "---> Fatal! CERTIFICATE not set. Exiting"
    exit 1
  fi
  if [ -n "${CA_CERTIFICATE}" ]; then
    echo "---> Configuring Client: CA_CERTIFICATE"
    echo "${CA_CERTIFICATE}" > /home/deployer/.puppetlabs/etc/puppet/ssl/certs/ca.pem
  else
    echo "---> Fatal! CA_CERTIFICATE not set. Exiting"
    exit 1
  fi
fi

# System configuration
if [ -f /etc/puppetlabs/mcollective/plugin.d/choria.cfg ]; then
  echo "---> Configuring MCollective Choria Plugin"
  sed -i "s|PUPPETSERVER|$PUPPETSERVER|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|PUPPETCA|$CA_SERVER|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|PUPPETDB|$PUPPETDB|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|\[\"NATS\"\]|$NATS|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
else
  echo "---> Fatal! MCollective Choria plugin configuration file not found"
  exit 1
fi
