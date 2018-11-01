#!/usr/bin/env bash
set -e

DIR=/docker-entrypoint.d

# Run Puppetserver when asked to do so
if [ "$1" = 'puppetserver' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting Puppetserver ${PUPPET_SERVER_VERSION}"
  exec /opt/puppetlabs/bin/puppetserver foreground
fi

# Run CMD
exec "$@"
