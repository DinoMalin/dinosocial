all: up

up:
	docker compose watch

down:
	COMPOSE_PROFILES=test docker compose down --remove-orphans

tests:
	COMPOSE_PROFILES=test docker compose up

secrets: 
	bash secrets.sh

re: down up

.PHONY: all up down tests re
