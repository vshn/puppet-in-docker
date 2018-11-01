#!/usr/bin/env bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}
CERTFILE="/usr/local/etc/haproxy/ssl/certs/${CN}.pem"
KEYFILE="/usr/local/etc/haproxy/ssl/private_keys/${CN}.pem"
HAPROXY_PEM_FILE="/usr/local/etc/haproxy/ssl/haproxy.pem"
CRL_FILE="/usr/local/etc/haproxy/ssl/crl.pem"

if [ "${USE_LEGACY_CA_API}" == "true" ]; then
  CA_API_URL=https://${CA_SERVER}:8140/production/certificate/ca
  CRL_API_URL=https://${CA_SERVER}:8140/production/certificate_revocation_list/ca
else
  CA_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca
  CRL_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate_revocation_list/ca
fi

if [ "${SKIP_CRL_DOWNLOAD}" == "true" ]; then
  echo "---> Skipping CRL download from ${CA_SERVER}"
else
  while ! curl -k -s -f $CRL_API_URL > $CRL_FILE; do
    echo "---> Trying to download latest CRL from ${CA_SERVER}"
    sleep 10
  done
  chown haproxy $CRL_FILE
  echo "---> Downloaded latest CRL from ${CA_SERVER}"
fi

# Request certificate if not already available
if [ ! -f ${HAPROXY_PEM_FILE} ]; then

  if [[ ! -f ${CERTFILE} || ! -f ${KEYFILE} ]]; then
    # Wait for CA API to be available
    while ! curl -k -s -f $CA_API_URL > /dev/null; do
        echo "---> Waiting for CA API at ${CA_SERVER}..."
        sleep 10
    done

    echo "---> Requesting certificate for ${CN} from ${CA_SERVER}"
    su -s /bin/sh haproxy -c "/usr/bin/ruby \
        /usr/local/bin/request-cert.rb \
        --caserver ${CA_SERVER} \
        --cn ${CN} \
        --legacy ${USE_LEGACY_CA_API} \
        --ssldir /usr/local/etc/haproxy/ssl"

    if [ ! -f ${CERTFILE} ]; then
        echo "---> Certificate retrieval failed. Exiting"
        exit 1
    fi
  fi

  # Prepare certificate for HAProxy
  cat $CERTFILE $KEYFILE > $HAPROXY_PEM_FILE
fi
