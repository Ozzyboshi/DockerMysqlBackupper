# DockerMysqlBackupper
Docker script to automate mysql backups to Dropbox Google Drive and others


docker run --name mysqlbackupper -e DBHOST=some-mysql -e USERNAME=root -e PASSWORD=my-secret-pw -e SECONDS=60 --rm -e DBNAMES=lettureenel --link some-mysql  mysqlbackupper
docker start mysqlbackupper
