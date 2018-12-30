#!make

include config
export $(shell sed 's/=.*//' config)

MUCK_PROJECT ?= muck

certs:
	cd setup; ./run 

up:
	docker-compose -p ${MUCK_PROJECT} up -d

down:
	docker-compose -p ${MUCK_PROJECT} down

reindex:
	docker-compose -p ${MUCK_PROJECT} \
	  exec search /app/bin/indexer --all --rotate
