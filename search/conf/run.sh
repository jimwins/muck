#!/bin/sh

/app/bin/indexer --all

exec /app/bin/searchd --console --pidfile
