#!/bin/bash

CN=$(hostname)
CA_SERVER=${CA_SERVER:-puppetca.local}
AUTOSIGN=${AUTOSIGN:-true}

# Configure Puppetserver to be a CA when enabled
if [ "${CA}" != "enabled" ]; then
  echo "---> Disabling CA service"

  cat <<EOF>/etc/puppetlabs/puppetserver/services.d/ca.cfg
puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service
EOF

  # Request certificate if not already available
  if [ ! -f /etc/puppetlabs/puppet/ssl/certs/${CN}.pem ]; then
    # Wait for CA API to be available
    while ! curl -k -s -f https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca > /dev/null; do
      echo "---> Waiting for CA API at ${CA_SERVER}..."
      sleep 10
    done
    su -s /bin/sh puppet -c "/usr/local/bin/request-cert.rb ${CA_SERVER} ${CN}"
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

  while ! curl -k -s -f https://${CA_SERVER}:8140/puppet-ca/v1/certificate_revocation_list/ca > /etc/puppetlabs/puppet/ssl/crl.pem; do
    echo "---> Trying to download latest CRL from ${CA_SERVER}"
    sleep 10
  done
  echo "---> Downloaded latest CRL from ${CA_SERVER}"

else
  echo "---> Puppetserver acting as CA"
  echo "---> Configuring autosigning: ${AUTOSIGN}"
  puppet config set autosign $AUTOSIGN --section master
fi
