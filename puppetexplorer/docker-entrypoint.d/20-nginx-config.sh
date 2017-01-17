#!/bin/bash

PUPPETDB_SERVER=${PUPPETDB_SERVER:-puppetdb.local}

if [ -n "$PUPPETDB_SERVER" ]; then
  echo "---> Configuring Nginx with PuppetDB hostname: $PUPPETDB_SERVER"
  sed -i "s|PUPPETDB_SERVER|$PUPPETDB_SERVER|" /etc/nginx/nginx.conf
else
  echo "---> Fatal: Missing PUPPETDB_SERVER environment variable. Exiting."
  exit 1
fi
