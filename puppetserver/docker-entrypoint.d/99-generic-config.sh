#!/bin/bash

readonly config_re='^PUPPETCONF_([^_]+)_(.+)$'

# https://stackoverflow.com/a/39529897
env -0 |
while IFS='=' read -r -d '' name value; do
  if [[ "$name" =~ $config_re ]]; then
    section=${BASH_REMATCH[1]}
    key=${BASH_REMATCH[2]}
    echo "---> Configuring Puppetserver - Section ${section,,}: ${key,,} = $value"
    puppet config set --section "${section,,}" "${key,,}" "$value"
  fi
done

