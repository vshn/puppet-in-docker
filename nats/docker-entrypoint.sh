#!/bin/bash
set -e

DIR=/docker-entrypoint.d

# Run NATS when asked to do so
if [ "$1" = 'nats' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /usr/bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting NATS ${NATS_VERSION}"
  exec /lib/ld-musl-x86_64.so.1 /usr/local/bin/gnatsd -c /etc/nats/gnatsd.conf
fi

# Run CMD
exec "$@"
