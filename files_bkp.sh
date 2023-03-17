#!/bin/bash

docker ps -f 'name=_wp' --format '{{.Names}}' > DOCKER_NAME.list
mapfile -t DOCKER_NAME < DOCKER_NAME.list
# DOCKER_NAME=("$DELIMITER$DOCKER_NAME$DELIMITER")
# DOCKER_NAME=($DOCKER_NAME)
# echo 'DOCKER_NAME='$DOCKER_NAME''
# DOCKER_NAME=($DOCKER_NAME)
# DOCKER_NAME="yael.krg-23.com_wp"
LOCAL_BKP="/root/docker/wp/backups"
echo 'LOCAL_BKP='$LOCAL_BKP''
NOW=$(date +"%Y-%m-%d_%H-%M_%S")
echo 'NOW=$NOW'
LOGDIR="/var/log/wp_bkp/"
echo 'LOGDIR='$LOGDIR''
LOGFILE=$null

# DOCKER_number=$(DOCKER ps -f 'name=_wp' --format '{{.Names}}' | wc -l)
[ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"
for DOCKER in "${DOCKER_NAME[@]}"; do
   LOGFILE="$NOW-$DOCKER-file.log"
   echo 'LOGFILE='$LOGFILE''
   echo "Running backup for '$DOCKER' files" >> $LOGDIR$LOGFILE
   echo "$NOW '$DOCKER' files backup initiated" >> $LOGDIR$LOGFILE
   docker run --rm --volumes-from $DOCKER -v $LOCAL_BKP:/backup wordpress tar zcfP /backup/$DOCKER-files-$NOW.tar.gz /var/www/html
   echo "$NOW $DOCKER files backup ended" >> $LOGDIR$LOGFILE
done

