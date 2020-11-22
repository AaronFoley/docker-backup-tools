#!/bin/bash
# A simple script to backup and roll over database backups

BACKUP_DIR=${BACKUP_DIR:-/data/backup/}
DAYS_KEPT=${DAYS_KEPT:-90}
MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PWD=${MYSQL_PWD:-mysecret}

DATESTAMP=$(date +%d-%m-%y-%H-%M)

# Get all databases
DB_LIST=`mysqlshow -h $MYSQL_HOST -u $MYSQL_USER | grep "|"| tr -d ' '|tr -d '|'| egrep -v Databases`

for DB in $DB_LIST;
do
    echo "Backing up: $DB"
    FILENAME=${BACKUP_DIR}${DB}-${DATESTAMP}.sql.gz
    mysqldump -h $MYSQL_HOST -u $MYSQL_USER $DB --single-transaction | gzip > $FILENAME
done

# remove backups older than $DAYS_KEPT
echo "Removing backups older than $DAYS_KEPT days"
find ${BACKUP_DIR}* -mtime +$DAYS_KEPT -exec rm -f {} \; 2> /dev/null
