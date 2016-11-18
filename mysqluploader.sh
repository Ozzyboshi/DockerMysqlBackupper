#!/bin/bash

if [ -z "$TARGETDIR" ]; then
    echo "Targetdir env var not found"
    exit 1
fi

for target in $(grep '^\[.*\]$' /root/.rclone.conf  | cut -c 2- | rev | cut -c 2- | rev); do
	echo 'rclone sync /var/lib/automysqlbackup $target:/automysqlbackup/'
	rclone sync /var/lib/automysqlbackup $target:/$TARGETDIR
done
