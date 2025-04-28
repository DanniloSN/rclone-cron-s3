#!/bin/bash

set -euo pipefail

mkdir -p "/logs"

BACKUP_DIR="/backups"
LOG_FILE="/logs/rclone-backup_$(date +%Y-%m-%d-%H-%M-%S).log"

AWS_S3_BUCKET_PATH="${AWS_S3_BUCKET_PATH#/}"

DESTINATION_DIR=":s3:$AWS_S3_BUCKET"
if [ -n "$AWS_S3_BUCKET_PATH" ]; then
  DESTINATION_DIR="$DESTINATION_DIR/$AWS_S3_BUCKET_PATH"
fi

echo "[INFO] $(date) - Starting sync from $BACKUP_DIR to $DESTINATION_DIR" >> "$LOG_FILE"

rclone sync "$BACKUP_DIR" "$DESTINATION_DIR" \
  --s3-provider AWS \
  --s3-env-auth \
  --s3-region "$AWS_REGION" \
  --s3-no-check-bucket \
  --s3-force-path-style \
  --s3-bucket-acl private \
  --copy-links \
  --progress \
  --verbose >> "$LOG_FILE" 2>&1

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "[INFO] $(date) - Sync completed successfully" >> "$LOG_FILE"
else
  echo "[ERROR] $(date) - Sync failed with exit code $RESULT" >> "$LOG_FILE"
fi

