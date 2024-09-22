.SILENT .PHONY: help build-development build-performance build-test build-no-cache up start down
.SILENT .PHONY: destroy terminal test-quality phpstan initialize-env enable-xdebug disable-xdebug

help: ## Shows this help
	@grep -E '^[a-zA-Z0-9 -]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*##"}; {printf "\033[1;32m%-15s\033[0m %s\n", $$1, $$2}'

build-no-cache:
	 NO_CACHE="--no-cache"

build-development: ## Build for development (without XDebug)
	docker-compose -f docker-compose.yml -f docker-compose.development.yml build $(NO_CACHE)

build-performance: ## Build for performance (with XDebug)
	docker-compose -f docker-compose.yml -f docker-compose.performance.yml build $(NO_CACHE)

build-test: ## Build test environment with test database
	docker-compose -f docker-compose.yml -f docker-compose.test.yml build $(NO_CACHE)

up: ## Start containers with the selected configuration
	docker-compose up -d

start-development: down build-development up ## Start development mode without XDebug

start-performance: down build-performance up ## Start performance mode with XDebug

test-development: down ## Start development mode with test database
	docker-compose -f docker-compose.yml -f docker-compose.development.yml -f docker-compose.test.yml up -d

test-performance: down ## Start performance mode with test database
	docker-compose -f docker-compose.yml -f docker-compose.performance.yml -f docker-compose.test.yml up -d

down: ## Stop the docker containers
	docker-compose down

destroy: ## Remove the docker containers and volumes
	docker-compose down -v --rmi all

terminal: # Enter web terminal
	docker exec -it web bash

test-up: build-test

test: test-quality test-unit # Run quality tests and unit tests

test-unit: build-test
	vendor/bin/phpunit

test-quality: php-cs-fixer php-code-sniffer phpstan # Run quality tests (phpstan)

phpstan:
	./vendor/bin/phpstan analyze

php-cs-fixer:
	./vendor/bin/php-cs-fixer fix -n -v

php-code-sniffer:
	./vendor/bin/phpcs --standard=PSR12 src -p

initialize-env:
	cp .env.test .env
