# ============================================================
# Lab 04 — Variables condicionales con ?= (SOLUCIÓN)
# ============================================================

.PHONY: config servidor origen help

.DEFAULT_GOAL := help

# ── Configuración del servidor ────────────────────────────────
SERVER_HOST ?= localhost
SERVER_PORT ?= 8080

# ── Configuración de base de datos ────────────────────────────
DB_HOST     ?= localhost

# ── Logging ───────────────────────────────────────────────────
LOG_LEVEL   ?= info

## config: muestra la configuración actual
config:
	@echo "Configuración actual:"
	@echo "  SERVER_HOST: $(SERVER_HOST)"
	@echo "  SERVER_PORT: $(SERVER_PORT)"
	@echo "  DB_HOST:     $(DB_HOST)"
	@echo "  LOG_LEVEL:   $(LOG_LEVEL)"

## servidor: simula inicio de servidor
servidor:
	@echo "Iniciando servidor..."
	@echo "  Escuchando en $(SERVER_HOST):$(SERVER_PORT)"
	@echo "  Log level: $(LOG_LEVEL)"
	@echo "Servidor listo."

## origen: muestra de dónde sale el valor de cada variable
origen:
	@echo "SERVER_HOST: $(origin SERVER_HOST)"
	@echo "SERVER_PORT: $(origin SERVER_PORT)"
	@echo "HOME:        $(origin HOME)"
	@echo "NO_EXISTE:   $(origin NO_EXISTE)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [SERVER_HOST=host] [SERVER_PORT=puerto]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
