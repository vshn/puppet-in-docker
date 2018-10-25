#!/usr/bin/env bash
VOLUME_PREFIX=${VOLUME_PREFIX:-puppetindocker}
volumes="
${VOLUME_PREFIX}_ca_data
${VOLUME_PREFIX}_ca_ssl
${VOLUME_PREFIX}_db_ssl
${VOLUME_PREFIX}_haproxy_ssl
${VOLUME_PREFIX}_nats_ssl
${VOLUME_PREFIX}_postgres
${VOLUME_PREFIX}_r10k_cache
${VOLUME_PREFIX}_r10k_env
${VOLUME_PREFIX}_r10k_ssl
${VOLUME_PREFIX}_server_data
${VOLUME_PREFIX}_server_ssl
"

case $1 in
  'data' )
    for v in $volumes; do
      echo docker run --rm -v $v:/data busybox sh -c \"rm -rf /data/*\"
      docker run --rm -v $v:/data busybox sh -c "rm -rf /data/*"
    done
    ;;
  'volumes' )
    for v in $volumes; do
      echo docker volume rm $v
      docker volume rm $v
    done
    ;;
esac
