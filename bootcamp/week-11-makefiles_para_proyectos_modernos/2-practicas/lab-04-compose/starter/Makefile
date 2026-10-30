.PHONY: all up down logs ps restart exec info help
.DEFAULT_GOAL := help

STACK_NAME := mi-stack
SERVICE    ?= web

# Compose v2 viene integrado en Docker. docker-compose (v1) está en EOL desde 2023.
COMPOSE := docker compose

# TODO 1: Define el target 'up'
#   Levanta el stack en modo detached: $(COMPOSE) up -d
#   Imprime "Stack arriba. Logs: make logs"


# TODO 2: Define el target 'down'
#   Detiene y elimina contenedores: $(COMPOSE) down
#   Imprime "Stack detenido."


# TODO 3: Define el target 'logs'
#   Muestra logs del servicio $(SERVICE) en tiempo real: $(COMPOSE) logs -f $(SERVICE)


# TODO 4: Define el target 'ps'
#   Muestra el estado de los contenedores: $(COMPOSE) ps


# TODO 5: Define el target 'restart'
#   Reinicia el servicio $(SERVICE): $(COMPOSE) restart $(SERVICE)
#   Pista: usa la variable SERVICE con valor por defecto 'web' (ya definida arriba)
#   Imprime "Reiniciando $(SERVICE)..." antes del comando


# TODO 6: Define el target 'exec'
#   Abre un shell en el contenedor $(SERVICE): $(COMPOSE) exec $(SERVICE) sh


info: ## Mostrar información del stack
	@echo "Stack:    $(STACK_NAME)"
	@echo "Compose:  $(COMPOSE)"
	@echo "Servicios: web db"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
