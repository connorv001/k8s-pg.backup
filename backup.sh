#!/bin/bash
export DUMP_FILE=/backup_`date +%Y%m%d_%H%M%S`.pgdump
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -d $POSTGRES_DB -U $POSTGRES_USER -h $POSTGRES_HOST -f $DUMP_FILE
bzip2 $DUMP_FILE
mcrypt ${DUMP_FILE}.bz2 -k $DB_BACKUP_PASSWORD
aws s3 cp ${DUMP_FILE}.bz2.nc $S3_BACKUP_PATH
