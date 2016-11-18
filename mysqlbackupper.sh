#!/bin/bash

if [ ! -f "/root/.rclone.conf" ]; then rclone config;exit 0; fi

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
fi

if [ -z "$DBNAMES" ]; then
    echo "Set database names in DBNAMES env var"
    exit 1
fi

if [ -z "$TARGETDIR" ]; then
    echo "Targetdir env var not found"
    exit 1
fi


sed -i '/DBHOST=localhost/c\DBHOST='"$DBHOST"'' /etc/default/automysqlbackup
sed -i '7 i\USERNAME='"$USERNAME"'' /etc/default/automysqlbackup
sed -i '10 i\PASSWORD='"$PASSWORD"'' /etc/default/automysqlbackup
sed -i '/^DBNAMES=/c\DBNAMES='"$DBNAMES"'' /etc/default/automysqlbackup

watch -n1 --interval $SECONDS  'automysqlbackup ; /mysqluploader.sh'
