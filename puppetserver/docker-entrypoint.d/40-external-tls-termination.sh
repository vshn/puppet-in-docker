#!/bin/bash

echo "---> Configuring Puppetserver to accept SSL verification headers"
sed -i 's/version: 1/version: 1\n    allow-header-cert-info: true/' /etc/puppetlabs/puppetserver/conf.d/auth.conf
