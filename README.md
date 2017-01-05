# DockerMysqlBackupper
Dockermysqlbackupper is a docker container for automating mysql backups to Dropbox, Google Drive and others.

DockerMysqlBackupper relies on automysqlbackup for backupping and on rclone for remote syncing.

## Prerequisites
Before using DockerMysqlBackupper you must have a working .rclone.conf file to feed rclone, if you don't have one you can generate it easily with DockerMysqlBackupper itself, for example:

  mkdir rclone
  docker run --rm -v /home/ozzy/rclone:/root -it ozzyboshi/dockermysqlbackupper
  
This will start the rclone configuration wizards, at the end you will get a new .rclone.conf file withing the rclone directory you just created.

## Start the backup process
To start the backup process you must run the container in daemon mode passing the options in the appropriate environment variables, for example the following command will backup every 60 seconds the database 'mydatabase' connecting to the mysql server listening at 127.0.0.1:3306 tcp using login=root and password=my-secret-pw.
The backup files will be stored into the remote directory automysqlbackup/machine1.

  docker run --name mysqlbackupper -e DBHOST=some-mysql -e USERNAME=root -e PASSWORD=my-secret-pw -e SECONDS=60 -e DBNAMES=mydatabase -e TARGETDIR=automysqlbackup/machine1 -d -t ozzyboshi/dockermysqlbackupper

## Example
In the following example I am going to backup the database nextcloud from a mysql listening on 10.0.12:3306 tcp into my Google Drive starting from scratch.
At the first run we must generate a rclone.conf file for Google Drive:

```
docker run --rm -v /home/ozzy/rclone:/root -it ozzyboshi/dockermysqlbackupper
  2017/01/05 13:18:25 Failed to load config file "/root/.rclone.conf" - using defaults: open /root/.rclone.conf: no such file or directory
  No remotes found - make a new one
  n) New remote
  s) Set configuration password
  q) Quit config
  n/s/q> n
  name> Nextcloud gdrive backup
  Type of storage to configure.
  Choose a number from below, or type in your own value
   1 / Amazon Drive
     \ "amazon cloud drive"
   2 / Amazon S3 (also Dreamhost, Ceph, Minio)
     \ "s3"
   3 / Backblaze B2
     \ "b2"
   4 / Dropbox
     \ "dropbox"
   5 / Encrypt/Decrypt a remote
     \ "crypt"
   6 / Google Cloud Storage (this is not Google Drive)
     \ "google cloud storage"
   7 / Google Drive
     \ "drive"
   8 / Hubic
     \ "hubic"
   9 / Local Disk
     \ "local"
  10 / Microsoft OneDrive
     \ "onedrive"
  11 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
     \ "swift"
  12 / Yandex Disk
     \ "yandex"
  Storage> 7
  Google Application Client Id - leave blank normally.
  client_id> 
  Google Application Client Secret - leave blank normally.
  client_secret> 
  Remote config
  Use auto config?
   * Say Y if not sure
   * Say N if you are working on a remote or headless machine or Y didn't work
  y) Yes
  n) No
  y/n> n
  If your browser doesn't open automatically go to the following link: https://accounts.google.com/o/oauth2/auth?client_id=aaaaaaaa.apps.googleusercontent.com&redirect_uri=bbbbbbbbbbbbbbb&response_type=code&scope=ccccccccccc&state=ddd
  Log in and authorize rclone for access
```  
  
Now copy and paste the url to your browser, at the end of the process you will get an authorization code from google, paste it after the verification code prompt:

```
  Enter verification code> #enter code
  --------------------
  [Nextcloud gdrive backup]
  client_id = 
  client_secret = 
  token = {"access_token":"aaaaa","token_type":"Bearer","refresh_token":"bbbbb","expiry":"2017-01-05T14:19:39.025613576Z"}
  --------------------
  y) Yes this is OK
  e) Edit this remote
  d) Delete this remote
  y/e/d> y
  Current remotes:

  Name                 Type
  ====                 ====
  Nextcloud gdrive backup drive

  e) Edit existing remote
  n) New remote
  d) Delete remote
  s) Set configuration password
  q) Quit config
  e/n/d/s/q> q
```

Now it's time to launch the backupper damon :

```
docker run --name mysqlbackupper -v $(HOME)/rclone:/root -e DBHOST=10.0.0.14 -e USERNAME=root -e PASSWORD=my-secret-pw -e SECONDS=86400 -e DBNAMES=nextcloud -e TARGETDIR=automysqlbackup/nextcloud -d -t  ozzyboshi/dockermysqlbackupper
```

Time go to your grive account and you should see a automysqlbackup/nextcloud directory with your automated backups.
