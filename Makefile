.PHONY: help build build-no-cache up start down destroy terminal

help:
	@echo "Usage:"
	@echo "  make build   	- Build the Docker images"
	@echo "  make up      	- Start the Docker containers"
	@echo "  make down    	- Stop the Docker containers"
	@echo "  make destroy 	- Remove the Docker containers and volumes"
	@echo "  make terminal 	- Enter the php terminal"

build-no-cache:
	 NO_CACHE="--no-cache"

build:
	docker-compose build $(NO_CACHE)

up:
	docker-compose up -d

start: build-no-cache up

down:
	docker-compose down

destroy:
	docker-compose down -v --rmi all

terminal:
	docker exec -it api bash
