#!/bin/bash

echo "[INFO] $(date) - Starting sync to S3"

rclone sync /to-copy "s3:${AWS_BUCKET}/${AWS_BUCKET_PATH}" \
  --s3-provider AWS \
  --s3-region "${AWS_REGION}" \
  --progress \
  --verbose

echo "[INFO] $(date) - Sync completed"

