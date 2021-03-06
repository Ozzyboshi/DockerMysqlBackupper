#!/bin/bash

if [ -z "$TARGETDIR" ]; then
    echo "Targetdir env var not found"
    exit 1
fi

printf '%s\n' "$(grep '^\[.*\]$' /root/.rclone.conf | cut -c 2- | rev | cut -c 2- | rev)" | while IFS= read -r target
do
	rclone sync /var/lib/automysqlbackup "$target":/"$TARGETDIR"
done
