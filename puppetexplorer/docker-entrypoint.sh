#!/usr/bin/env bash
set -e

DIR=/docker-entrypoint.d

# Run Nginx when asked to do so
if [ "$1" = 'nginx' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /usr/bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting Nginx"
  exec nginx
fi

# Run CMD
exec "$@"
