#!/usr/bin/env bash
set -e

DIR=/docker-entrypoint.d

# Execute entrypoint hooks (runtime configurations)
if [ -d "$DIR" ]; then
  echo "===> Executing entrypoint hooks under docker-entrypoint.d"
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
  echo "===> End of hooks"
fi

# Run CMD
exec "$@"
