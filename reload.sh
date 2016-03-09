rancher-compose --url $CATTLE_CONFIG_URL \
  --access-key $CATTLE_ACCESS_KEY --secret-key $CATTLE_SECRET_KEY \
  -p $RANCHER_PROMETHEUS_STACK restart --batch-size 1 $RANCHER_PROMETHEUS_SERVICE
