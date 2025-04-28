#!/bin/bash

BACKUP_DIR="/backups"

LOG_FOLDER="/logs"
mkdir -p "$LOG_FOLDER"

LOG_FOLDER="$LOG_FOLDER/rclone-backup_$(date +%Y-%m-%d-%H-%M-%S).log"

echo "[INFO] $(date) - Starting sync from $BACKUP_DIR to S3" >> "$LOG_FOLDER"

rclone sync $BACKUP_DIR \
  "s3:$AWS_S3_BUCKET/$AWS_S3_BUCKET_PATH" \
  --s3-provider AWS \
  --s3-env-auth \
  --s3-region "${AWS_REGION}" \
  --s3-no-check-bucket \
  --s3-force-path-style \
  --s3-bucket-acl private \
  --progress \
  --verbose >> "$LOG_FOLDER" 2>&1

echo "[INFO] $(date) - Sync completed" >> "$LOG_FOLDER"

