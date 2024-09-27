.SILENT .PHONY:
help: # Shows this help
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.SILENT .PHONY:
build-no-cache:
	 NO_CACHE="--no-cache"

.SILENT .PHONY:
build-development: # Build for development (without XDebug)
	docker-compose -f docker-compose.yml -f docker-compose.development.yml build $(NO_CACHE)

.SILENT .PHONY:
build-performance: # Build for performance (with XDebug)
	docker-compose -f docker-compose.yml -f docker-compose.performance.yml build $(NO_CACHE)

.SILENT .PHONY:
up: # Start containers with the selected configuration
	docker-compose up -d

.SILENT .PHONY:
start-development: down build-development up # Start development mode without XDebug

.SILENT .PHONY:
start-performance: down build-performance up # Start performance mode with XDebug

.SILENT .PHONY:
test-development: # Start development mode with test database
	docker-compose -f docker-compose.test.yml -f docker-compose.development.yml up -d

.SILENT .PHONY:
test-performance: # Start performance mode with test database
	docker-compose -f docker-compose.test.yml -f docker-compose.performance.yml up -d

.SILENT .PHONY:
down-test:
	docker-compose -f docker-compose.test.yml down

.SILENT .PHONY:
down: # Stop the docker containers
	docker-compose down

.SILENT .PHONY:
destroy: # Remove the docker containers and volumes
	docker-compose down -v --rmi all

.SILENT .PHONY:
terminal: # Enter web terminal
	docker exec -it web bash

.SILENT .PHONY:
test: test-quality test-performance test-unit test-behat down-test # Run quality tests, unit tests and integration tests

.SILENT .PHONY:
test-unit: # Run unit tests
	@echo "\nRunning unit tests...\n"
	vendor/bin/phpunit

.SILENT .PHONY:
test-behat: # Run behat tests
	@echo "\nRunning behat tests...\n"
	vendor/bin/behat -f progress

.SILENT .PHONY:
test-quality: php-cs-fixer php-code-sniffer phpstan # Run quality tests (phpstan)

.SILENT .PHONY:
phpstan: # Analyze the code with PHPStan
	./vendor/bin/phpstan analyze

.SILENT .PHONY:
php-cs-fixer: # Analyze the code with PHP CS Fixer
	./vendor/bin/php-cs-fixer fix -n -v

.SILENT .PHONY:
php-code-sniffer: # Analyze the code with PHP CodeSniffer
	./vendor/bin/phpcs --standard=PSR12 src -p

.SILENT .PHONY:
initialize-env:
	cp .env.test .env
