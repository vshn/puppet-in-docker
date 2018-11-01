#!/usr/bin/env bash
set -e

DIR=/docker-entrypoint.d

# Run Puppetdb when asked to do so
if [ "$1" = 'puppetdb' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting PuppetDB ${PUPPETDB_VERSION}"
  exec /opt/puppetlabs/server/bin/puppetdb foreground
fi

# Run CMD
exec "$@"
