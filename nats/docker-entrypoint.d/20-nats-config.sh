#!/usr/bin/env bash

CN=$(hostname)
CERTFILE="/etc/nats/ssl/certs/${CN}.pem"
KEYFILE="/etc/nats/ssl/private_keys/${CN}.pem"
CAFILE="/etc/nats/ssl/certs/ca.pem"

if [ -f ${CERTFILE} ]; then
  echo "---> Configuring NATS certificates"
  sed -i "s|CERTFILE|$CERTFILE|" /etc/nats/gnatsd.conf
  sed -i "s|KEYFILE|$KEYFILE|" /etc/nats/gnatsd.conf
  sed -i "s|CAFILE|$CAFILE|" /etc/nats/gnatsd.conf
else
  echo "---> Fatal: Certificate for NATS at ${CERTFILE} missing. Exiting."
  exit 1
fi
