.PHONY: all up down logs ps restart exec info help
.DEFAULT_GOAL := help

STACK_NAME := mi-stack
SERVICE    ?= web

COMPOSE := $(shell docker compose version > /dev/null 2>&1 && echo "docker compose" || echo "docker-compose")

up: ## Levantar stack en modo detached
	$(COMPOSE) up -d
	@echo "Stack arriba. Logs: make logs"

down: ## Detener y eliminar contenedores
	$(COMPOSE) down
	@echo "Stack detenido."

logs: ## Ver logs del servicio (SERVICE=web por defecto)
	$(COMPOSE) logs -f $(SERVICE)

ps: ## Listar estado de los contenedores
	$(COMPOSE) ps

restart: ## Reiniciar un servicio (SERVICE=web por defecto)
	@echo "Reiniciando $(SERVICE)..."
	$(COMPOSE) restart $(SERVICE)

exec: ## Abrir shell en el contenedor (SERVICE=web por defecto)
	$(COMPOSE) exec $(SERVICE) sh

info: ## Mostrar información del stack
	@echo "Stack:    $(STACK_NAME)"
	@echo "Compose:  $(COMPOSE)"
	@echo "Servicios: web db"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
