#!/usr/bin/env bash
SSL_PATH=${SSL_PATH:-/etc/puppetlabs/puppet/ssl}
CERTS_PATH=${CERTS_PATH:-/etc/puppetlabs/puppet/ssl/certs}
KEYS_PATH=${KEYS_PATH:-/etc/puppetlabs/puppet/ssl/private_keys}

if [ -d "${CERTS_PROVISON_PATH}" ]; then
  echo "---> Copying cert and key files from ${CERTS_PROVISON_PATH} to /etc/puppetlabs/puppet/ssl/"
  mkdir -p "$CERTS_PATH" "$KEYS_PATH"
  cp "$CERTS_PROVISON_PATH"/certs/*.pem "${CERTS_PATH}/"
  cp "$CERTS_PROVISON_PATH"/private_keys/*.pem "${KEYS_PATH}/"
  chown -R puppetdb:root "$SSL_PATH";
fi
