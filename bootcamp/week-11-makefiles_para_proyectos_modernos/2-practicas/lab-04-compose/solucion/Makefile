SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all config up down logs ps restart exec info help
.DEFAULT_GOAL := help

STACK_NAME := mi-stack
SERVICE    ?= web

# Compose v2 viene integrado en Docker. docker-compose (v1) está en EOL desde 2023.
COMPOSE := docker compose

# .env no es phony: es un archivo. Si existe, no hay nada que hacer; si
# falta, esta regla falla con un mensaje claro antes de llamar a docker.
# Nunca se genera solo: una contraseña por defecto acabaría en producción.
.env:
	@echo "Falta .env: cp .env.example .env y cambia POSTGRES_PASSWORD" >&2
	@exit 1

config: .env ## Validar docker-compose.yml y .env sin levantar nada
	$(COMPOSE) config --quiet
	@echo "Configuración válida."

up: .env ## Levantar stack en modo detached
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
