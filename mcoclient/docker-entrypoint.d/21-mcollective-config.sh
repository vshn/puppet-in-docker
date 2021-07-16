#!/usr/bin/env bash

CA_SERVER=${CA_SERVER:-puppetca}
MCOLLECTIVE_CERTNAME=${MCOLLECTIVE_CERTNAME:-deployer.mcollective}
NATS=${NATS:-nats:4222}
PUPPETDB=${PUPPETDB:-puppetdb}
PUPPETSERVER=${PUPPETSERVER:-puppetserver}

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
if [ -f /etc/choria/plugin.d/choria.cfg ]; then
  echo "---> Configuring Choria Plugin"
  sed -i "s|PUPPETSERVER|$PUPPETSERVER|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|PUPPETCA|$CA_SERVER|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|PUPPETDB|$PUPPETDB|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|\[\"NATS\"\]|$NATS|" /etc/choria/plugin.d/choria.cfg
else
  echo "---> Fatal! Choria plugin configuration file not found"
  exit 1
fi
