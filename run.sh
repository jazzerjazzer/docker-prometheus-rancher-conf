#!/bin/bash

# borrowed from github.com/martinbaillie
wait_for_rancher_metadata() {
  counter=0
  printf '[prometheus-config] waiting for rancher-metadata to become available'
  until curl --output /dev/null --silent --head --fail http://rancher-metadata; do
    printf '.'
    sleep 1
    counter=$((counter + 1))
    if [ "$counter" -gt 10 ]; then
      echo
      echo "[prometheus-config] rancher-metadata never became available" >&2
      exit 1
    fi
  done
  echo
}

echo "[prometheus-config] waiting for rancher-metadata to become available"
wait_for_rancher_metadata
echo "[prometheus-config] watching for changes every ${CONFD_INTERVAL}s"
echo "${RANCHER_PROMETHEUS_SERVICE}:" > docker-compose.yml
confd -interval $CONFD_INTERVAL -backend rancher -prefix /2015-12-19
