.SILENT .PHONY: help build build-no-cache up start down destroy terminal test-quality phpstan initialize-env

help: ## Shows this help
	@grep -E '^[a-zA-Z0-9 -]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*##"}; {printf "\033[1;32m%-15s\033[0m %s\n", $$1, $$2}'

build-no-cache:
	 NO_CACHE="--no-cache"

build:
	docker-compose build $(NO_CACHE)

up:
	docker-compose up -d

start: build-no-cache up ## Build the docker images and start the docker containers

down: ## Stop the docker containers
	docker-compose down

destroy: ## Remove the docker containers and volumes
	docker-compose down -v --rmi all

terminal: # Enter web terminal
	docker exec -it web bash

test: test-quality test-unit # Run quality tests and unit tests

test-unit:
	docker exec -it web vendor/bin/phpunit

test-quality: phpstan # Run quality tests (phpstan)

phpstan:
	vendor/bin/phpstan analyze

initialize-env:
	cp .env.test .env