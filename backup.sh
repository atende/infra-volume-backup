#!/bin/ash

echo "Backuping Files..."
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

echo "Paths to backup: $PATHS_TO_BACKUP"

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# # Create bucket, if it doesn't already exist
BUCKET_EXIST=$(rclone lsd backup: | grep $BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  rclone mkdir backup:$BUCKET_NAME
fi

# # Upload the backup to S3 with timestamp
rclone copy --no-traverse $tarball backup:$BUCKET_NAME

# # Clean up
rm $tarball