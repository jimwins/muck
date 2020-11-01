#!make

include config
export $(shell sed 's/=.*//' config)

MUCK_PROJECT ?= muck

certs:
	cd setup; ./run 

pull:
	docker-compose -p ${MUCK_PROJECT} pull

up:
	docker-compose -p ${MUCK_PROJECT} up -d

down:
	docker-compose -p ${MUCK_PROJECT} down

reindex:
	mysql -NB scat -e 'SELECT CONCAT(source, " => ", dest) FROM wordform' |\
          grep -v mysql > search/wordforms.txt
	docker-compose -p ${MUCK_PROJECT} restart search
	curl https://scat.${MUCK_HOST}/catalog/~reindex
