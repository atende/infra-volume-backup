#!/bin/ash

echo "Restoring Files..."
# Find last backup file
: ${LAST_BACKUP:=$(rclone ls backup:$BUCKET_NAME | awk -F " " '{print $2}' | grep ^$BACKUP_NAME | sort -r | head -n1)}
echo "Last backup file: ${LAST_BACKUP}"
if [ -n "$LAST_BACKUP" ]; then

  # Download backup from S3
  rclone copy backup:$BUCKET_NAME/$LAST_BACKUP /
  echo "Waiting transferer to complete"
  sleep 1
  # Extract backup
  tar -xzf $LAST_BACKUP $RESTORE_TAR_OPTION
else
  echo "Could not locate last backup"
fi