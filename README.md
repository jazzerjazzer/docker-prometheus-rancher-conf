# docker-prometheus-rancher-conf
Automatic Prometheus monitoring for Rancher

This container is made to be a sidekick container to automatically configure a prometheus instance.

## How to

Run the `prom/prometheus` container with volumes_from set to this image. Run this image as a sidekick in rancher.

Next, apply `prometheus.monitor=true` as a label to any container that you would like to be monitored by Prometheus. By default prometheus will scan `/metrics` on port `3000`. To override the port use `prometheus.monitor.port=<port>`
