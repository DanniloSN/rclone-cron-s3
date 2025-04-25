#!/bin/bash

# Replace cron expression from env
envsubst < /crontab.template > /etc/crontabs/root

echo "[INFO] Starting cron job: $CRON_SCHEDULE"
crond -f -L /dev/stdout
