FROM alpine:3.4
MAINTAINER  Giovanni Silva <giovanni@atende.info>

ENV RCLONE_VERSION v1.34

ENV BUCKET_NAME docker-backups.example.com
ENV PATHS_TO_BACKUP /paths/to/backup
ENV BACKUP_NAME backup
ENV RESTORE false

RUN apk add --update --no-cache ca-certificates tar

RUN wget -q -O rclone.zip http://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-amd64.zip \
    && unzip rclone.zip \
    && cp rclone-v*-linux-amd64/rclone /usr/bin \
    && rm rclone.zip \
    && rm -r rclone* 


ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
ADD setup.sh /setup.sh
RUN chmod 755 /*.sh

VOLUME /root

CMD ["/run.sh"]
