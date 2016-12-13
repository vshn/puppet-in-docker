#!/bin/bash
set -e

DIR=/docker-entrypoint.d

# Run HAProxy when asked to do so
if [ "$1" = 'haproxy' ]; then
  # Execute entrypoint hooks (runtime configurations)
  if [ -d "$DIR" ]; then
    echo "===> Executing entrypoint hooks under docker-entrypoint.d"
    /usr/bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
    echo "===> End of hooks"
  fi

  echo "===> Starting HAProxy (and syslogd)"
  exec /bin/sh -c \
    "/sbin/syslogd -O /dev/stdout && \
    sleep 5 && \
    /usr/local/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg"
fi

# Run CMD
exec "$@"
