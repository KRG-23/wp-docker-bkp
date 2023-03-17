#! /bin/bash
> DOCKER_DB.list
docker ps -f 'name=_db' --no-trunc --format '{{.Names}}' > DOCKER_DB.list # extract list of containers names to source file
mapfile -t DOCKER_DB < DOCKER_DB.list # create array from source file
# DOCKER_DB=("$DELIMITER$DOCKER_DB$DELIMITER")
# DOCKER_DB=($DOCKER_DB)
# echo 'DOCKER_DB='$DOCKER_DB''
# DOCKER_DB=($DOCKER_DB)
# DOCKER_DB="yael.krg-23.com_wp"
LOCAL_BKP="/root/docker/wp/backups"
echo 'LOCAL_BKP='$LOCAL_BKP''
NOW=$(date +"%Y-%m-%d_%H-%M_%S")
echo 'NOW=$NOW'
LOGDIR="/var/log/wp_bkp/"
echo 'LOGDIR='$LOGDIR''
LOGFILE=$null
TEMPFILE="/tmp/docker-run.cmd"
TEMPFILE2="/tmp/docker-run2.cmd"
# DOCKER_number=$(DOCKER ps -f 'name=_wp' --format '{{.Names}}' | wc -l)
[ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"
for DOCKER in "${DOCKER_DB[@]}"; do
   LOGFILE="$DOCKER-$NOW-db.log"
   echo 'LOGFILE='$LOGFILE''
   echo "$NOW Running backup for '$DOCKER' SQL DB" >> $LOGDIR$LOGFILE
   echo "$NOW Running backup for '$DOCKER' SQL DB"
   echo "$NOW Running history command for '$DOCKER' container" >> $LOGDIR$LOGFILE
   echo "$NOW Running history command for '$DOCKER' container"
   echo "$NOW Zeroing TEMPFILEs" >> $LOGDIR$LOGFILE
   echo "$NOW Zeroing TEMPFILEs"   
   > $TEMPFILE
   > $TEMPFILE2
   echo "$NOW Getting '$DOCKER' launch command and sending to '$TEMPFILE'" >> $LOGDIR$LOGFILE
   echo "$NOW Getting '$DOCKER' launch command and sending to '$TEMPFILE'"
   docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro assaflavie/runlike $DOCKER > $TEMPFILE
   echo "$NOW Checking $TEMPFILE content: $(cat $TEMPFILE)" >> $LOGDIR$LOGFILE
   echo "$NOW Checking $TEMPFILE content: $(cat $TEMPFILE)"
   echo "$NOW Done." >> $LOGDIR$LOGFILE
   echo "$NOW Done."
   echo "$NOW Running variables assignment" >> $LOGDIR$LOGFILE
   echo "$NOW Running variables assignment"
   grep -oE 'MYSQL_DATABASE=[^" "]*|MYSQL_USER=[^" "]*|name=[^" "]*' $TEMPFILE > $TEMPFILE2
   echo "$(cat $TEMPFILE2)" >> $LOGDIR$LOGFILE
   echo "$(cat $TEMPFILE2)"
   sed -e '2d' -e 's/.*=//' $TEMPFILE2 > $TEMPFILE
   echo "$NOW Checking final $TEMPFILE content: $(cat $TEMPFILE)" >> $LOGDIR$LOGFILE
   echo "$NOW Checking final $TEMPFILE content: $(cat $TEMPFILE)"
   echo "$NOW Done." >> $LOGDIR$LOGFILE
   echo "$NOW Done."
   mapfile -t DOCKER_DB_ARRAY < $TEMPFILE
   echo "$NOW Testing sub array: ${DOCKER_DB_ARRAY[*]}" >> $LOGDIR$LOGFILE
   echo "$NOW Testing sub array: ${DOCKER_DB_ARRAY[*]}"
   echo "$NOW '$DOCKER' SQL dump initiated" >> $LOGDIR$LOGFILE
   echo "$NOW '$DOCKER' SQL dump initiated"
   # set DB variables for docker command
   DBUSERNAME=${DOCKER_DB_ARRAY[2]}
   echo "$NOW DB username is '$DBNAME'" >> $LOGDIR$LOGFILE
   DBPASSWORD="$(cat ../pwd)"
   echo "$NOW DB password is '$DBPASSWORD'" >> $LOGDIR$LOGFILE
   DBNAME=${DOCKER_DB_ARRAY[1]}
   echo "$NOW DB name is '$DBNAME'" >> $LOGDIR$LOGFILE
   DBDUMPNAME=${DOCKER_DB_ARRAY[0]}
   echo "$NOW DB dump name is '$DBDUMPNAME'" >> $LOGDIR$LOGFILE
   # echo "'$(docker exec $DOCKER mysqldump --no-tablespaces -u$DBUSERNAME -p$DBPASSWORD $DBNAME)" >> $LOGDIR$LOGFILE
   # echo "'$(docker exec $DOCKER mysqldump --no-tablespaces -u$DBUSERNAME -p$DBPASSWORD $DBNAME)"
   docker exec $DOCKER mysqldump --no-tablespaces -u$DBUSERNAME -p$DBPASSWORD $DBNAME > $DBDUMPNAME-database-backup.sql
   # done
   # docker run --rm --volumes-from $DOCKER -v $LOCAL_BKP:/backup wordpress tar zcfP /backup/$DOCKER-files-$NOW.tar.gz /var/www/html
   # docker exec mjb.krg-23.com_db mysqldump --no-tablespaces -umjb_user -p'Lhoos1eoQ-' mjb_db > mjb.krg-23.com_db-database-backup.sql
   # docker exec $DOCKER mysqldump --no-tablespaces -umjb_user -p'Lhoos1eoQ-' mjb_db > $DOCKER-database-backup.sql
   echo "$NOW Done." >> $LOGDIR$LOGFILE
   echo "$NOW Done."
   echo "$NOW Zeroing TEMPFILEs" >> $LOGDIR$LOGFILE
   echo "$NOW Zeroing TEMPFILEs"   
   > $TEMPFILE
   > $TEMPFILE2 
   echo "$NOW Emptying DB array" >> $LOGDIR$LOGFILE
   echo "$NOW Emptying DB array"
   unset DOCKER_DB_ARRAY
   echo "$NOW $DOCKER SQL backup ended" >> $LOGDIR$LOGFILE
   echo "$NOW $DOCKER SQL backup ended"
done

