.SILENT .PHONY: help build build-no-cache up start down destroy terminal tests phpstan

help: ## Shows this help
	@grep -E '^[a-zA-Z0-9 -]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*##"}; {printf "\033[1;32m%-15s\033[0m %s\n", $$1, $$2}'

build-no-cache:
	 NO_CACHE="--no-cache"

build:
	docker-compose build $(NO_CACHE)

up:
	docker-compose up -d

start: ## Build the docker images and start the docker containers
	build-no-cache up

down: ## Stop the docker containers
	docker-compose down

destroy: ## Remove the docker containers and volumes
	docker-compose down -v --rmi all

terminal: # Enter web terminal
	docker exec -it web bash

tests: # Run tests (phpstan)
	phpstan

phpstan:
	vendor/bin/phpstan analyze
