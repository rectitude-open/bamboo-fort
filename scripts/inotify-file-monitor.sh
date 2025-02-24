#!/bin/bash

MONITOR_DIRS="/home/wwwroot/aaa.com/public/wp-admin /home/wwwroot/aaa.com/public/wp-includes"
EXCLUDE_PATTERN="(^/home/wwwroot/aaa.com/public/wp-admin/images)"
EMAIL_TO="admin@rectitude.dev"
EMAIL_SUBJECT="File Tampering Detected"
BUFFER_TIME=60
LAST_EMAIL_TIME=0
LOG_FILE="/var/log/inotify_file_monitor.log"

inotifywait -m -r \
  -e modify,create,delete,move \
  --exclude "$EXCLUDE_PATTERN" \
  $MONITOR_DIRS |
while read path action file; do
  CURRENT_TIME=$(date +%s)
  LOG_MESSAGE="$(TZ='Asia/Shanghai' date '+%Y-%m-%d %H:%M:%S') [$action] $path$file"
  echo "$LOG_MESSAGE" >> "$LOG_FILE"

  if (( CURRENT_TIME - LAST_EMAIL_TIME > BUFFER_TIME )); then
    echo -e "$LOG_MESSAGE\nCheck the log for details: $LOG_FILE" | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO"
    LAST_EMAIL_TIME=$CURRENT_TIME
  fi
done
