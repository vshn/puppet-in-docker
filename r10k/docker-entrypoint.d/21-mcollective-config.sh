#!/usr/bin/env bash

CA_SERVER=${CA_SERVER:-puppetca.local}
NATS=${NATS:-nats.local:4222}
PUPPETDB=${PUPPETDB:-puppetdb.local}
PUPPETSERVER=${PUPPETSERVER:-puppetserver.local}

if [ -z "${CN}" ]; then
  CN=$(hostname)
fi
IDENTITY=$CN

if [ -f /etc/puppetlabs/mcollective/plugin.d/choria.cfg ]; then
  echo "---> Configuring MCollective Choria Plugin"
  sed -i "s|PUPPETSERVER|$PUPPETSERVER|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|PUPPETCA|$CA_SERVER|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|PUPPETDB|$PUPPETDB|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
  sed -i "s|\[\"NATS\"\]|$NATS|" /etc/puppetlabs/mcollective/plugin.d/choria.cfg
else
  echo "---> MCollective Choria plugin configuration file not found"
fi

if [ -f /etc/puppetlabs/mcollective/client.cfg ]; then
  echo "---> Configuring MCollective Client"
  sed -i "s|IDENTITY|$IDENTITY|" /etc/puppetlabs/mcollective/client.cfg
fi

if [ -f /etc/puppetlabs/mcollective/server.cfg ]; then
  echo "---> Configuring MCollective Server"
  sed -i "s|IDENTITY|$IDENTITY|" /etc/puppetlabs/mcollective/server.cfg
fi
