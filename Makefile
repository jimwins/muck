#!make

include config
export $(shell sed 's/=.*//' config)

certs:
	cd setup; ./run 

hosts:
	./bin/update-hosts
