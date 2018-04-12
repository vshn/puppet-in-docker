#!/bin/bash

echo "---> Configuring PuppetDB whitelist"
if [ "$PUPPETDB_WHITELIST" ]; then
  sed -i -E "s/(# )?certificate\-whitelist:/certificate-whitelist:/" /etc/puppetlabs/puppetdb/conf.d/config.conf
fi
