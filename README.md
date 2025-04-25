# Rclone Cron Docker Image

This Docker image runs a cron job using `rclone` to sync files from a local folder to an S3 bucket on a scheduled basis.

## Features

- Synchronizes files from a specified local folder (`/to-copy`) to an S3 bucket.
- Configurable cron schedule.
- AWS authentication via environment variables.
- No need for `rclone.conf` file.

## How it works

This container runs a cron job that performs a sync operation using `rclone` based on the frequency defined in the `CRON_SCHEDULE` environment variable.

## Cron Job

The cron job runs the following command:

```bash
rclone sync /to-copy "s3:${AWS_BUCKET}/${AWS_BUCKET_PATH}" \
  --s3-provider AWS \
  --s3-region "${AWS_REGION}" \
  --progress \
  --verbose
```

## Requirements

To use this container, you need to have the following environment variables set:

- `CRON_SCHEDULE`: Cron expression defining the schedule for the sync job (e.g., `0 * * * *` for every hour).
- `AWS_ACCESS_KEY_ID`: Your AWS access key for authentication.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key for authentication.
- `AWS_REGION`: The AWS region where your S3 bucket is located.
- `AWS_BUCKET`: The name of the S3 bucket.
- `AWS_BUCKET_PATH`: The path inside the S3 bucket where files should be copied.

## Example Usage

To run the container and sync files from a local directory to an S3 bucket, use the following `docker run` command:

```bash
docker run -d \
  --name rclone-cron \
  -v /local/path/to/backup:/to-copy:ro \
  -e CRON_SCHEDULE="*/30 * * * *" \
  -e AWS_ACCESS_KEY_ID=your_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret \
  -e AWS_REGION=us-east-1 \
  -e AWS_BUCKET=my-bucket-name \
  -e AWS_BUCKET_PATH=backups/my-folder \
  your-dockerhub-user/rclone-cron
```

## This command will

- Run the container in the background (`-d`).
- Mount the local folder `/local/path/to/backup` to `/to-copy` inside the container (read-only).
- Set the environment variables for AWS authentication and configuration.
- Set the cron job to run every 30 minutes (`*/30 * * * *`).

## Customizing the Cron Schedule

You can customize the cron schedule by changing the `CRON_SCHEDULE` environment variable. For example:

- `*/5 * * * *` → Every 5 minutes
- `0 0 * * *` → Every day at midnight
- `0 * * * *` → Every hour

## License

Include the license if applicable (e.g., MIT, Apache 2.0, etc.).