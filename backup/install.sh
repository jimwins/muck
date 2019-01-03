#! /bin/sh

GOCRON=https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz

# exit if a command fails
set -e

apk update

# install stuff
apk add mysql-client python py-pip curl tzdata

# install b2 client
pip install --upgrade b2

# install go-cron
curl -L --insecure $GOCRON | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apk del curl

# cleanup
rm -rf /var/cache/apk/*
