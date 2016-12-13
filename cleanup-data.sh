#!/bin/bash
volumes="
docker_ca_data
docker_ca_ssl
docker_db_ssl
docker_haproxy_ssl
docker_nats_ssl
docker_postgres
docker_r10k_cache
docker_r10k_env
docker_r10k_ssl
docker_server_data
docker_server_ssl
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
