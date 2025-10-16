all: up

up:
	docker compose watch

down:
	COMPOSE_PROFILES=test docker compose down --remove-orphans

tests: down
	COMPOSE_PROFILES=test docker compose up --build --abort-on-container-exit --exit-code-from tests
	$(MAKE) down

secrets: 
	bash secrets.sh

re: down up

.PHONY: all up down tests re
