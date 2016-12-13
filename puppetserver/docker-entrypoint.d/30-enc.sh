#!/bin/bash

if [ -n "$PUPPET_ENC" ]; then
  echo "---> Configuring Puppetserver to use ENC ${PUPPET_ENC}"
  puppet config set node_terminus exec --section master
  puppet config set external_nodes $PUPPET_ENC --section master
fi
