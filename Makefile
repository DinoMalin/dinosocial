all: up

up:
	docker compose up

down:
	docker compose down --remove-orphans

re: down up
