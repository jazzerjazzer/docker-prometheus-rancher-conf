#!/bin/bash

echo "[prometheus-config] watching for changes every ${CONFD_INTERVAL}s"
confd -interval $CONFD_INTERVAL -backend rancher -prefix /2015-12-19
