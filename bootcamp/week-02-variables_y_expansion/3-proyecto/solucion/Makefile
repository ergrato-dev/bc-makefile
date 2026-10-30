# ============================================================
# Proyecto Semana 02 — Makefile parametrizable multi-entorno (SOLUCIÓN)
# ============================================================

.PHONY: config build test deploy clean help

.DEFAULT_GOAL := help

# ── Configuración del proyecto ────────────────────────────────
APP_NAME  ?= mywebservice
ENV       ?= dev
REGISTRY  ?= registry.local
LOG_LEVEL ?= info

# ── Versión ───────────────────────────────────────────────────
# := ejecuta git una sola vez; ?= deja que VERSION llegue desde CLI o entorno
GIT_VERSION := $(shell git describe --tags --always 2>/dev/null || echo "0.1.0")
VERSION     ?= $(GIT_VERSION)
BUILD_DATE  := $(shell date +%F)

# ── Tags e imagen ─────────────────────────────────────────────
# = se evalúa al usarse: sigue a ENV y VERSION aunque cambien después de esta
# línea (por ejemplo, con una variable específica de target)
IMAGE_TAG   = $(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)

# ── Base de datos ─────────────────────────────────────────────
DB_HOST    ?= localhost
DB_NAME     = $(APP_NAME)_$(ENV)
DB_URL      = postgres://$(DB_HOST):5432/$(DB_NAME)

# ── Flags de build ────────────────────────────────────────────
# BUILD_ARGS es configurable, pero --pull es obligatorio: override hace que
# el += se aplique aunque BUILD_ARGS llegue por la línea de comandos
BUILD_ARGS ?=
override BUILD_ARGS += --pull

config: ## muestra la configuración completa del entorno actual
	@echo "Entorno:    $(ENV)"
	@echo "Versión:    $(VERSION)"
	@echo "Fecha:      $(BUILD_DATE)"
	@echo "Imagen:     $(IMAGE_TAG)"
	@echo "DB URL:     $(DB_URL)"
	@echo "Log level:  $(LOG_LEVEL)"
	@echo "Origen ENV: $(origin ENV)"

build: ## construye la imagen de la aplicación
	@echo "[build] Construyendo $(APP_NAME):$(VERSION)-$(ENV)..."
	@echo "[build] Flags: $(BUILD_ARGS)"
	@echo "[build] Compilación OK."
	@echo "[build] Imagen lista: $(IMAGE_TAG)"

test: ## ejecuta la suite de pruebas
	@echo "[test] Ejecutando suite de pruebas en entorno: $(ENV)"
	@echo "[test] Tests OK."

deploy: build test ## construye, prueba y despliega en el entorno configurado
	@echo "[deploy] Desplegando en $(ENV)..."
	@echo "[deploy]   Imagen: $(IMAGE_TAG)"
	@echo "[deploy]   DB:     $(DB_URL)"
	@echo "[deploy] Deploy OK."

clean: ## elimina artefactos de build
	@echo "[clean] Limpiando artefactos..."
	@rm -rf dist/
	@echo "[clean] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
