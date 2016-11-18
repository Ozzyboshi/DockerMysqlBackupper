#!/bin/bash
for target in $(grep '^\[.*\]$' /root/.rclone.conf  | cut -c 2- | rev | cut -c 2- | rev); do
	echo 'rclone sync /var/lib/automysqlbackup $target:/automysqlbackup/var/lib/automysqlbackup'
	bash -c 'rclone sync /var/lib/automysqlbackup $target:/automysqlbackup/'
done
