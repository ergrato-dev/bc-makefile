# ============================================================
# Lab 04 — Variables condicionales con ?=
# Semana 02: Variables y Expansión en Make
# ============================================================
# Prueba los tres modos:
#   make config                          → usa defaults
#   make config SERVER_PORT=9090         → override desde CLI
#   SERVER_HOST=10.0.0.1 make config     → override desde entorno
# ============================================================

.PHONY: config servidor help

.DEFAULT_GOAL := help

# ── Configuración del servidor ────────────────────────────────
# TODO: define SERVER_HOST con ?= y valor "localhost"
# SERVER_HOST ?= ...

# TODO: define SERVER_PORT con ?= y valor "8080"
# SERVER_PORT ?= ...

# ── Configuración de base de datos ────────────────────────────
# TODO: define DB_HOST con ?= y valor "localhost"
# DB_HOST ?= ...

# ── Logging ───────────────────────────────────────────────────
# TODO: define LOG_LEVEL con ?= y valor "info"
# LOG_LEVEL ?= ...

## config: muestra la configuración actual
config:
	@echo "Configuración actual:"
	# TODO: @echo "  SERVER_HOST: $(SERVER_HOST)"
	# TODO: @echo "  SERVER_PORT: $(SERVER_PORT)"
	# TODO: @echo "  DB_HOST:     $(DB_HOST)"
	# TODO: @echo "  LOG_LEVEL:   $(LOG_LEVEL)"

## servidor: simula inicio de servidor
servidor:
	@echo "Iniciando servidor..."
	# TODO: @echo "  Escuchando en $(SERVER_HOST):$(SERVER_PORT)"
	# TODO: @echo "  Log level: $(LOG_LEVEL)"
	@echo "Servidor listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [SERVER_HOST=host] [SERVER_PORT=puerto]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
