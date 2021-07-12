#!/usr/bin/env bash

CA_SERVER=${CA_SERVER:-puppetca.local}
NATS=${NATS:-nats.local:4222}
PUPPETDB=${PUPPETDB:-puppetdb.local}
PUPPETSERVER=${PUPPETSERVER:-puppetserver.local}

if [ -z "${CN}" ]; then
  CN=$(hostname)
fi
IDENTITY=$CN

if [ -f /etc/choria/plugin.d/choria.cfg ]; then
  echo "---> Configuring Choria plugin"
  sed -i "s|PUPPETSERVER|$PUPPETSERVER|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|PUPPETCA|$CA_SERVER|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|PUPPETDB|$PUPPETDB|" /etc/choria/plugin.d/choria.cfg
  sed -i "s|\[\"NATS\"\]|$NATS|" /etc/choria/plugin.d/choria.cfg
else
  echo "---> Choria plugin configuration file not found"
fi

if [ -f /etc/choria/client.cfg ]; then
  echo "---> Configuring Choria client"
  sed -i "s|IDENTITY|$IDENTITY|" /etc/choria/client.cfg
fi

if [ -f /etc/choria/server.cfg ]; then
  echo "---> Configuring Choria server"
  sed -i "s|IDENTITY|$IDENTITY|" /etc/choria/server.cfg
fi
