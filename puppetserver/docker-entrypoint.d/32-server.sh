#!/usr/bin/env bash

if [ -n "$PUPPET_SERVER" ]; then
  echo "---> Configuring Puppet to use server ${PUPPET_SERVER} (e.g. for API calls)"
  puppet config set server "$PUPPET_SERVER" --section server
fi
