# Infra Volume Backup

Docker volume backup of files to S3 and other cloud storages

Base on https://github.com/tutumcloud/dockup but with some improviments:

* Use [Rclone] which makes possible to backup to other cloud providers like
dropbox and other S3 compatible storages. So is not coupled with Amazon
* Based on Alpine Linux image, which makes the image very small

# Usage

You have a container running with one or more volumes:

```
$ docker run -d --name mysql tutum/mysql
```

From executing a `$ docker inspect mysql` we see that this container has two volumes:

```
"Volumes": {
            "/etc/mysql": {},
            "/var/lib/mysql": {}
        }
```

## Backup
Launch `volume-backup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--volumes-from mysql \
--name backup atende/volume-backup:latest
```

The contents of `env.txt` being:

```
RCONF_TYPE=s3
RCONF_ACCESS_KEY_ID=<key_here>
RCONF_SECRET_ACCESS_KEY=<secret_here>
RCONF_REGION=other-v2-signature
RCONF_ENDPOINT=s3.provider.com
BACKUP_NAME=mysql
BUCKET_NAME=docker-backups.example.com
PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
RESTORE=false
```

`volume-backup` will create a rconfig file with all RCONF_XX variables as name value par

For example, the variable **RCONF_TYPE=s3** is transformed to **type = s3** and added to the file. 
Check [http://rclone.org/docs/](http://rclone.org/docs/) for all options

You can also mount the **.rclone.conf** file in the **/root** volume and ignore the *RCONF_* env variables:

    docker run --rm \
    -v $(pwd)/root \
    --volumes-from mysql \
    -e BACKUP_NAME=mysql -e BUCKET_NAME=docker-backups.example.com
    -e PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
    --name backup atende/volume-backup:latest

RESTORE is false by default

The command above will mount your current directory to the /root directory of the container, you must create the .rclone.conf 
file and still need the other env variables

Rclone has a command line that helps you in the creation of the file to all its providers: `rclone config`

## Restore
To restore your data simply set the `RESTORE` environment variable to `true` - this will restore the latest backup from your storage to your volume.

The **BUCKET\_NAME** is used to create the rcopy command for example a BUCKET\_NAME=folder and BACKUP\_NAME=temp will create the command:

    rclone copy --no-traverse temp.2016-11-27-10-50.tar.gz backup:folder

If _folder_ doesn't exist it will be created.

It will have different semantics in different storages. In S3 this is a bucket name, in other could be just a folder.

For the sake of completeness, restore command is: 

    rclone copy backup:$BUCKET_NAME/$LAST_BACKUP /


[Rclone]: http://rclone.org/