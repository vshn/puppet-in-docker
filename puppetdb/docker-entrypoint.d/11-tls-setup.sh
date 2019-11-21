#!/usr/bin/env bash

if [ -z "${CN}" ]; then
  CN=$(hostname)
fi

CA_SERVER=${CA_SERVER:-puppetca.local}
CERTFILE="/etc/puppetlabs/puppet/ssl/certs/${CN}.pem"

CA_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate/ca
CRL_API_URL=https://${CA_SERVER}:8140/puppet-ca/v1/certificate_revocation_list/ca

echo "---> Ensure correct permissions on puppet ssl certificates"
chown -R puppetdb:root /etc/puppetlabs/puppet/ssl

# Request certificate if not already available
if [ ! -f ${CERTFILE} ]; then
  # Wait for CA API to be available
  while ! curl -k -s -f ${CA_API_URL} > /dev/null; do
    echo "---> Waiting for CA API at ${CA_SERVER}..."
    sleep 10
  done

  echo "---> Requesting certificate for ${CN} from ${CA_SERVER}"
  su -s /bin/sh puppetdb -c "/usr/bin/ruby \
    /usr/local/bin/request-cert.rb \
    --caserver ${CA_SERVER} \
    --cn ${CN} \
    --ssldir /etc/puppetlabs/puppet/ssl"

  if [ ! -f ${CERTFILE} ]; then
    echo "---> Certificate retrieval failed. Exiting"
    exit 1
  fi
fi

echo "---> Configuring PuppetDB to use SSL"
# Configure PuppetDB to use the certificate requested above
cat <<EOF>/etc/puppetlabs/puppetdb/conf.d/jetty.ini
[jetty]
host = 0.0.0.0
port = 8080
ssl-host = 0.0.0.0
ssl-port = 8081
ssl-key = /etc/puppetlabs/puppet/ssl/private_keys/${CN}.pem
ssl-cert = ${CERTFILE}
ssl-ca-cert = /etc/puppetlabs/puppet/ssl/certs/ca.pem
access-log-config = /etc/puppetlabs/puppetdb/logging/request-logging.xml
EOF

