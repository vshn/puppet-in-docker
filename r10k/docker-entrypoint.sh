#!/usr/bin/env bash
set -e

DIR=/docker-entrypoint.d

# Run r10k when asked to do so
if [ "$1" = 'r10k' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting r10k ${R10K_VERSION} and Choria server"
  ln -sf /proc/1/fd/1 /var/log/choria.log
  exec /usr/bin/choria server run --config /etc/choria/server.conf
fi

# Run CMD
exec "$@"
