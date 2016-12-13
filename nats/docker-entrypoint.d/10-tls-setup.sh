#!/bin/bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}
CERTFILE="/etc/nats/ssl/certs/${CN}.pem"

# Request certificate if not already available
if [ ! -f ${CERTFILE} ]; then
  # Wait for CA API to be available
  while ! curl -k -s -f https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca > /dev/null; do
    echo "---> Waiting for CA API at ${CA_SERVER}..."
    sleep 10
  done

  echo "---> Requesting certificate for ${CN} from ${CA_SERVER}"
  # TODO investigate why the permissions are wrong
  # -> should be set correctly in Dockerfile
  # -> maybe gets overwriten because of volume mount
  # -> but in Puppetserver it works
  chown -R nats /etc/nats
  su -s /bin/sh nats -c "/usr/local/bin/request-cert.rb ${CA_SERVER} ${CN}"

  if [ ! -f ${CERTFILE} ]; then
    echo "---> Certificate retrieval failed. Exiting"
    exit 1
  fi
fi

