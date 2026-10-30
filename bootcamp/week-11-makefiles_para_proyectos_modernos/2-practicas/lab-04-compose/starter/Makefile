# TODO 0: Preámbulo estricto (Semana 03), antes de cualquier otra línea:
#         SHELL := bash
#         .SHELLFLAGS := -eu -o pipefail -c
#         .DELETE_ON_ERROR:

.PHONY: all config up down logs ps restart exec info help
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

# TODO 7: Precondición .env. Sin .env, 'docker compose up' falla con un
#   mensaje de interpolación poco claro. Haz que Make falle antes:
#   - Regla de archivo '.env' (NO phony) cuya receta imprima por stderr
#     "Falta .env: cp .env.example .env y cambia POSTGRES_PASSWORD" y salga con 1
#   - 'up' depende de .env
#   - Target 'config' que dependa de .env y ejecute $(COMPOSE) config --quiet
#     e imprima "Configuración válida."


help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
