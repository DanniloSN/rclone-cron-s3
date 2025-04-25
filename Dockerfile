FROM rclone/rclone:latest

RUN apk add --no-cache bash curl coreutils gettext

COPY entrypoint.sh /entrypoint.sh
COPY rclone-cron.sh /rclone-cron.sh
COPY crontab.template /crontab.template

RUN chmod +x /entrypoint.sh /rclone-cron.sh

ENTRYPOINT ["/entrypoint.sh"]
