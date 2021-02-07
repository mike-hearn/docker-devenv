.DEFAULT_GOAL := help
.PHONY: help

help:
	@echo
	@grep '^[[:alnum:]_-]*:.* ##' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN {FS=":.* ## "}; {printf "%-25s %s\n", $$1, $$2};'

#########

SHELL=/bin/bash

USERID := $(shell id -u)
GROUPID := $(shell id -g)

run: ## Run personal env
	USERID=${USERID} GROUPID=${GROUPID} docker-compose run personalenv /bin/bash

exec: ## Exec bash shell into container
	USERID=${USERID} GROUPID=${GROUPID} docker-compose exec personalenv /bin/bash

up: ## Bring up docker-compose env
	USERID=${USERID} GROUPID=${GROUPID} docker-compose up

down: ## Take down docker-compose env
	docker-compose down

build: ## Rebuild docker container(s)
	USERID=${USERID} GROUPID=${GROUPID} docker-compose build
