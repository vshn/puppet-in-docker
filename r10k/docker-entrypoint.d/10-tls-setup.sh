#!/bin/bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}

# Request certificate if not already available
if [ ! -f /etc/puppetlabs/puppet/ssl/certs/${CN}.pem ]; then
  # Wait for CA API to be available
  while ! curl -k -s -f https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca > /dev/null; do
    echo "---> Waiting for CA API at ${CA_SERVER}..."
    sleep 10
  done
  set -e
  /opt/puppetlabs/puppet/bin/mco choria request_cert
fi
