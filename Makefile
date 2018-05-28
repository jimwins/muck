#!make

include config
export $(shell sed 's/=.*//' config)

certs:
	cd setup; ./run 

hosts:
	./bin/update-hosts

up:
	docker-compose up -d

down:
	docker-compose down

reindex:
	docker-compose exec search /app/bin/indexer --all --rotate
