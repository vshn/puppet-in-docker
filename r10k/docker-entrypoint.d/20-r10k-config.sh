#!/bin/bash

if [ -n "$R10K_REPO" ]; then
  echo "---> Configuring r10k repository: $R10K_REPO"
  sed -i "s|R10K_REPO|$R10K_REPO|" /etc/puppetlabs/r10k/r10k.yaml
else
  echo "---> Missing R10K_REPO configuration. Skipping r10k configuration"
fi

if [ -n "$R10K_DEPLOY_KEY" ]; then
  echo "---> Saving SSH deploy key to /root/.ssh/id_rsa"
  echo "$R10K_DEPLOY_KEY" > /root/.ssh/id_rsa
  chmod 0400 /root/.ssh/id_rsa
fi

if [ -n "$MCO_R10K_POLICY" ]; then
  echo "---> Configuring custom MCollective policy for r10k"
  echo "$MCO_R10K_POLICY" > /etc/puppetlabs/mcollective/policies/r10k.policy
else
  echo "---> Configuring default MCollective policy for r10k"
  echo "policy default allow" > /etc/puppetlabs/mcollective/policies/r10k.policy
fi
