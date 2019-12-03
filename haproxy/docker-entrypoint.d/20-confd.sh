#!/usr/bin/env bash

export STATS_CRED=${STATS_CRED:-"admin:password"}
export PUPPETCA_BACKEND=${PUPPETCA_BACKEND:-puppetca.local}
export PUPPETDB_BACKEND=${PUPPETDB_BACKEND:-puppetdb.local}
export PUPPETEXPLORER_BACKEND=${PUPPETEXPLORER_BACKEND:-puppetexplorer.local}
export PUPPETSERVER_BACKEND=${PUPPETSERVER_BACKEND:-puppetserver.local}
if [ -z "${PUPPETSERVER_CATALOG_BACKEND}" ]; then
  export PUPPETSERVER_CATALOG_BACKEND=$PUPPETSERVER_BACKEND
fi
export SYSLOG_SERVER=${SYSLOG_SERVER:-localhost:2514}

echo "---> Configuring HAProxy with confd"
confd -backend env -onetime
