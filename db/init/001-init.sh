#!/usr/bin/env bash
set -e
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} create scat
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} create ordure
mysql -uroot -p${MYSQL_ROOT_PASSWORD} \
      -e "GRANT ALL PRIVILEGES ON scat.* TO '${MYSQL_USER}'@'%';" \
      -e "GRANT ALL PRIVILEGES ON ordure.* TO '${MYSQL_USER}'@'%';"
