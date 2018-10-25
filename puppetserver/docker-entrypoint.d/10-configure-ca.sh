#!/usr/bin/env bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}
CA_TTL=${CA_TTL:-5y}
AUTOSIGN=${AUTOSIGN:-true}

if [ "${USE_LEGACY_CA_API}" == "true" ]; then
  CA_API_URL=https://${CA_SERVER}:8140/production/certificate/ca
  CRL_API_URL=https://${CA_SERVER}:8140/production/certificate_revocation_list/ca
else
  CA_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca
  CRL_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate_revocation_list/ca
fi

# Configure Puppetserver to be a CA when enabled
if [ "${CA}" != "enabled" ]; then
  echo "---> Disabling CA service"

  cat <<EOF>/etc/puppetlabs/puppetserver/services.d/ca.cfg
puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service
EOF

  # Request certificate if not already available
  if [ ! -f /etc/puppetlabs/puppet/ssl/certs/${CN}.pem ]; then
    # Wait for CA API to be available
    while ! curl -k -s -f $CA_API_URL > /dev/null; do
      echo "---> Waiting for CA API at ${CA_SERVER}..."
      sleep 10
    done
    su -s /bin/sh puppet -c "/opt/puppetlabs/puppet/bin/ruby \
      /usr/local/bin/request-cert.rb \
      --caserver ${CA_SERVER} \
      --cn ${CN} \
      --legacy ${USE_LEGACY_CA_API} \
      --ssldir /etc/puppetlabs/puppet/ssl;
      exit $?"
  fi

  cat <<EOF>/etc/puppetlabs/puppetserver/conf.d/webserver.conf
webserver: {
    access-log-config: /etc/puppetlabs/puppetserver/request-logging.xml
    client-auth: want
    ssl-host: 0.0.0.0
    ssl-port: 8140
    ssl-cert: /etc/puppetlabs/puppet/ssl/certs/${CN}.pem
    ssl-key: /etc/puppetlabs/puppet/ssl/private_keys/${CN}.pem
    ssl-ca-cert: /etc/puppetlabs/puppet/ssl/certs/ca.pem
    ssl-crl-path: /etc/puppetlabs/puppet/ssl/crl.pem
}
EOF

  if [ "${SKIP_CRL_DOWNLOAD}" == "true" ]; then
    echo "---> Skipping CRL download from ${CA_SERVER}"
  else
    while ! curl -k -s -f $CRL_API_URL > /etc/puppetlabs/puppet/ssl/crl.pem; do
      echo "---> Trying to download latest CRL from ${CA_SERVER}"
      sleep 10
    done
    chown puppet /etc/puppetlabs/puppet/ssl/crl.pem
    echo "---> Downloaded latest CRL from ${CA_SERVER}"
  fi

else
  echo "---> Puppetserver acting as CA"
  echo "---> Configuring autosigning: ${AUTOSIGN}"
  puppet config set autosign $AUTOSIGN --section master
  if [ -n "${CA_NAME}" ]; then
    echo "---> Configuring CA Cert CN: ${CA_NAME}"
    puppet config set ca_name "$CA_NAME" --section master
  fi
  echo "---> Configuring CA Expire / TTL to now +${CA_TTL}"
  puppet config set ca_ttl "$CA_TTL" --section master
fi
