#! /bin/sh

set -e

if [ "${B2_ACCOUNT_ID}" == "**None**" ]; then
  echo "Warning: You did not set the B2_ACCOUNT_ID environment variable."
fi

if [ "${B2_APPLICATION_KEY}" == "**None**" ]; then
  echo "Warning: You did not set the B2_APPLICATION_KEY environment variable."
fi

if [ "${B2_BUCKET}" == "**None**" ]; then
  echo "You need to set the B2_BUCKET environment variable."
  exit 1
fi

if [ "${MYSQL_HOST}" == "**None**" ]; then
  echo "You need to set the MYSQL_HOST environment variable."
  exit 1
fi

if [ "${MYSQL_USER}" == "**None**" ]; then
  echo "You need to set the MYSQL_USER environment variable."
  exit 1
fi

if [ "${MYSQL_PASSWORD}" == "**None**" ]; then
  echo "You need to set the MYSQL_PASSWORD environment variable or link to a container named MYSQL."
  exit 1
fi

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
DUMP_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")

# Authorize to B2
b2 authorize-account ${B2_ACCOUNT_ID} ${B2_APPLICATION_KEY}

copy_backup () {
  SRC_FILE=$1
  DEST_FILE=$2

  echo "Uploading ${DEST_FILE} ..."

  b2 upload-file --noProgress ${B2_BUCKET} $SRC_FILE $DEST_FILE

  if [ $? != 0 ]; then
    >&2 echo "Error uploading ${DEST_FILE}"
  fi

  rm $SRC_FILE
}

# Multi file: yes
if [ ! -z "$(echo $MULTI_FILES | grep -i -E "(yes|true|1)")" ]; then
  if [ "${MYSQLDUMP_DATABASE}" == "--all-databases" ]; then
    DATABASES=`mysql $MYSQL_HOST_OPTS -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys|innodb)"`
  else
    DATABASES=$MYSQLDUMP_DATABASE
  fi

  for DB in $DATABASES; do
    echo "Creating individual dump of ${DB} from ${MYSQL_HOST}..."

    DUMP_FILE="/tmp/${DB}.sql.gz"

    mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS --databases $DB \
      | gzip -9 > $DUMP_FILE

    if [ $? == 0 ]; then
      if [ "${B2_FILENAME}" == "**None**" ]; then
        B2_FILE="${DUMP_START_TIME}.${DB}.sql.gz"
      else
        B2_FILE="${B2_FILENAME}.${DB}.sql.gz"
      fi

      copy_backup $DUMP_FILE $B2_FILE
    else
      >&2 echo "Error creating dump of ${DB}"
    fi
  done
# Multi file: no
else
  echo "Creating dump for ${MYSQLDUMP_DATABASE} from ${MYSQL_HOST}..."

  DUMP_FILE="/tmp/dump.sql.gz"
  mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQLDUMP_DATABASE \
    | gzip -9 > $DUMP_FILE

  if [ $? == 0 ]; then
    if [ "${B2_FILENAME}" == "**None**" ]; then
      B2_FILE="${DUMP_START_TIME}.dump.sql.gz"
    else
      B2_FILE="${B2_FILENAME}.sql.gz"
    fi

    copy_backup $DUMP_FILE $B2_FILE
  else
    >&2 echo "Error creating dump of all databases"
  fi
fi

echo "SQL backup finished"
