#!/bin/bash

if [ -z "$DBHOST" ]; then
    DBHOST="localhost"
fi

if [ -z "$USERNAME" ]; then
    USERNAME="root"
fi

if [ -z "$PASSWORD" ]; then
    PASSWORD=""
fi

if [ -z "$SECONDS" ]; then
    SECONDS="3600"
    exit 1
fi

if [ ! -f "/root/.rclone.conf" ]; then rclone config; fi

sed -i '/DBHOST=localhost/c\DBHOST='"$DBHOST"'' /etc/default/automysqlbackup
sed -i '7 i\USERNAME='"$USERNAME"'' /etc/default/automysqlbackup
sed -i '10 i\PASSWORD='"$PASSWORD"'' /etc/default/automysqlbackup
if [ -z "$DBNAMES" ]; then
    sed -i '/^DBNAMES=/c\DBNAMES='"$DBNAMES'"' /etc/default/automysqlbackup
fi
watch -n1 --interval $SECONDS  'automysqlbackup ; /mysqluploader.sh'
