#!/bin/bash

WORKDIR=$(pwd)
mkdir -p ${WORKDIR}/app/backup
echo "Creating backup folder ... 👜"

cd ${WORKDIR}/app/backup
echo "💿 Backup started at $(date)"

if mongodump  --uri ${MONGODB_URI} --out ${WORKDIR}/app/backup/mongo-dump_`date "+%Y-%m-%d-%T"` && 
   PGPASSWORD=${PGPASSWORD} pg_dumpall -U ${PG_USERNAME} -h ${PG_HOST} > ${WORKDIR}/app/backup/pg-dump_`date "+%Y-%m-%d-%T"`.sql &&
   aws s3 cp ${WORKDIR}/app/backup/ s3://$S3_BUCKET_NAME/db_backup/ --recursive
then
    echo "💿 😊 👍 Backup completed successfully at $(date)"
    echo " 📦 Uploaded to S3 bucket 😊 👍"
    tree ${WORKDIR}/app/backup
else
    echo  "📛❌📛❌ Backup failed at $(date)"
fi

echo "Cleaning up... 🧹"

rm -rf ${WORKDIR}/app/backup/ 

echo "Done 🎉"