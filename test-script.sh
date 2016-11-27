docker create -v /to-backup --name dbstore busybox /bin/true
docker run --rm --volumes-from dbstore -v $(pwd):/files busybox ash -c 'cp /files/* to-backup/'
docker run --rm --env-file env-example.txt \
--volumes-from dbstore --name backup-c atende/volume-backup