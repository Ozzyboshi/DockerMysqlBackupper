# DockerMysqlBackupper
Docker script to automate mysql backups to Dropbox Google Drive and others.

DockerMysqlBackupper relies on automysqlbackup for backupping and on rclone for remote syncing.

Usage : 

  docker run --name mysqlbackupper -e DBHOST=some-mysql -e USERNAME=root -e PASSWORD=my-secret-pw -e SECONDS=60 --rm -e DBNAMES=lettureenel --link some-mysql  ozzyboshi/mysqlbackupper

Automysqlbackup will use the environment variable DBHOST, USERNAME, PASSWORD and DBNAMES to fetch data from the mysql server and It will generate inside a container a backup directory under /var/lib/automysqlbackup/#databasename#.
Each time a backup is created this folder will be syncronized with your remote Dropbox or Google Drive accoring to how rclone is configured.

Rclone will be configured at first start invoking 'rclone config' and exiting, that means after the configuration you must restart the contanier manually with

  docker start mysqlbackupper
  

