#!/bin/bash

export STATS_CRED=${STATS_CRED:-"admin:password"}
export PUPPETSERVER_BACKEND=${PUPPETSERVER_BACKEND:-puppetserver.local}
export PUPPETCA_BACKEND=${PUPPETCA_BACKEND:-puppetca.local}
export PUPPETDB_BACKEND=${PUPPETDB_BACKEND:-puppetdb.local}

echo "---> Configuring HAProxy with confd"
confd -backend env -onetime
