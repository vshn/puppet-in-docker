#!/bin/bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}
CERTFILE="/usr/local/etc/haproxy/ssl/certs/${CN}.pem"
KEYFILE="/usr/local/etc/haproxy/ssl/private_keys/${CN}.pem"
HAPROXY_PEM_FILE="/usr/local/etc/haproxy/ssl/haproxy.pem"

# Request certificate if not already available
if [ ! -f ${HAPROXY_PEM_FILE} ]; then
  # Wait for CA API to be available
  while ! curl -k -s -f https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca > /dev/null; do
    echo "---> Waiting for CA API at ${CA_SERVER}..."
    sleep 10
  done

  echo "---> Requesting certificate for ${CN} from ${CA_SERVER}"
  su -s /bin/sh haproxy -c "/usr/local/bin/request-cert.rb ${CA_SERVER} ${CN}"

  if [ ! -f ${CERTFILE} ]; then
    echo "---> Certificate retrieval failed. Exiting"
    exit 1
  fi

  # Prepare certificate for HAProxy
  cat $CERTFILE $KEYFILE > $HAPROXY_PEM_FILE
fi
