# Rclone Cron Docker Image

This Docker image runs a scheduled cron job using rclone to sync files from a local folder to an S3 bucket.

## Features

- Syncs files from a specified local folder (`/backups`) to an S3 bucket.
- Fully configurable via environment variables.
- AWS authentication without requiring an `rclone.conf` file.
- Lightweight and simple to use.

## How it works

The container runs a cron job that executes an `rclone sync` based on the schedule defined in the `CRON_SCHEDULE` environment variable.

## Cron Job

The cron job runs the following command:

```bash
rclone sync "$BACKUP_DIR" "$DESTINATION_DIR" \
  --s3-provider AWS \
  --s3-env-auth \
  --s3-region "$AWS_REGION" \
  --s3-no-check-bucket \
  --s3-force-path-style \
  --s3-bucket-acl private \
  --verbose >> "$LOG_FILE" 2>&1
```

✅ Note: Authentication is handled automatically through environment variables (`--s3-env-auth`).

## Requirements

You must set the following environment variables:

- `CRON_SCHEDULE`: Cron expression defining the schedule for the sync job (e.g., `0 * * * *` for every hour).
- `AWS_ACCESS_KEY_ID`: Your AWS access key for authentication.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key for authentication.
- `AWS_REGION`: The AWS region where your S3 bucket is located.
- `AWS_S3_BUCKET`: The name of the S3 bucket.
- `AWS_S3_BUCKET_PATH`: The path inside the S3 bucket where files should be copied.

## Example Usage

To run the container and sync files from a local directory to an S3 bucket, use the following `docker run` command:

```bash
docker run -d \
  --name rclone-cron \
  -v /local/path/to/backup:/backups:ro \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e AWS_ACCESS_KEY_ID=your_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret \
  -e AWS_REGION=sa-east-1 \
  -e AWS_BUCKET=my-bucket-name \
  -e AWS_BUCKET_PATH=backups/my-folder \
  dannilosn/rclone-cron
```

## This command will

- Run the container in detached mode (`-d`).
- Mount the local backup folder as `/backups` (read-only).
- Use AWS credentials and configuration from environment variables.
- Run the sync job every 30 minutes.

## Customizing the Cron Schedule

Change the `CRON_SCHEDULE` variable as needed:

- `*/5 * * * *` → Every 5 minutes
- `0 0 * * *` → Every day at midnight
- `0 * * * *` → Every hour

## License

Include the license if applicable (e.g., MIT, Apache 2.0, etc.).
