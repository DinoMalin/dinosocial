all: up

up:
	docker compose up

down:
	COMPOSE_PROFILES=test docker compose down --remove-orphans

tests:
	COMPOSE_PROFILES=test docker compose up

re: down up

.PHONY: all up down tests re
