#!/bin/bash
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

  echo "===> Starting r10k ${R10K_VERSION} and MCollective server"
  ln -sf /proc/1/fd/1 /var/log/puppetlabs/mcollective.log
  exec /opt/puppetlabs/puppet/bin/mcollectived --no-daemonize
fi

# Run CMD
exec "$@"
