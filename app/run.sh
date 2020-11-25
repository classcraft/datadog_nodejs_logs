#!/bin/bash

set -e

sudo sh -c "sed -i 's/api_key:.*/api_key: $DD_API_KEY/' /etc/datadog-agent/datadog.yaml"

cat /etc/datadog-agent/datadog.yaml
cat /etc/datadog-agent/conf.d/nodejs.d/conf.yaml

initctl start datadog-agent

echo "Datadog agent started"

exec nodejs /app/main.js 2>&1 | tee >(multilog s1000000 n10 /app/logs) &

sleep 6

cat /app/logs/current
ls /var/log/datadog
