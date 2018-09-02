#!/usr/bin/env bash
mkdir -p /var/www/dehydrated
exec /srv/dehydrated/dehydrated -c --challenge "dns-01" \
       --hook /srv/dehydrated/dehydrated.default.sh \
       --config /app/config \
       --out /app/certs
