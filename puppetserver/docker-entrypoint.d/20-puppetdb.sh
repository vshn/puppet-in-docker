#!/bin/bash

CN=$(hostname)

if [ "${USE_LEGACY_PUPPETDB}" == "true" ]; then
  PUPPETDB_URL=https://${PUPPETDB_SERVER_URL}/v3/version
else
  PUPPETDB_URL=https://${PUPPETDB_SERVER_URL}/status/v1/services/puppetdb-status
fi

if [ -n "$PUPPETDB_SERVER_URL" ]; then
  # Wait for PuppetDB API to be available
  while ! curl -s -f $PUPPETDB_URL \
          --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem \
          --cert /etc/puppetlabs/puppet/ssl/certs/${CN}.pem \
          --key /etc/puppetlabs/puppet/ssl/private_keys/${CN}.pem > /dev/null; do
    echo "---> Waiting for PuppetDB API at ${PUPPETDB_SERVER_URL}..."
    sleep 10
  done
  echo "---> PuppetDB ready at ${PUPPETDB_SERVER_URL}..."

  echo "---> Configuring Puppetserver to connect to PuppetDB"
  cat <<EOF>/etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://${PUPPETDB_SERVER_URL}
soft_write_failure = true
EOF
  puppet config set storeconfigs_backend puppetdb --section main
  puppet config set storeconfigs true --section main
  puppet config set reports puppetdb --section main
fi
