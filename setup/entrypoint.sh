#!/usr/bin/env bash
mkdir -p /var/www/dehydrated
exec /srv/dehydrated/dehydrated -c --challenge "dns-01" \
       --domain "${MUCK_HOST} ordure.${MUCK_HOST} scat.${MUCK_HOST}" \
       --hook /srv/dehydrated/dehydrated.default.sh \
       --out /app/certs --config /app/config
