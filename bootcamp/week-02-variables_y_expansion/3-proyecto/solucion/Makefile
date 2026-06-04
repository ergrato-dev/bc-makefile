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
VERSION    ?= $(shell git describe --tags --always 2>/dev/null || echo "0.1.0")
BUILD_DATE := $(shell date +%F)

# ── Tags e imagen ─────────────────────────────────────────────
# = para que los overrides de ENV y VERSION del CLI se propaguen
IMAGE_TAG   = $(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)

# ── Base de datos ─────────────────────────────────────────────
DB_HOST    ?= localhost
DB_NAME     = $(APP_NAME)_$(ENV)
DB_URL      = postgres://$(DB_HOST):5432/$(DB_NAME)

## config: muestra la configuración completa del entorno actual
config:
	@echo "Entorno:    $(ENV)"
	@echo "Versión:    $(VERSION)"
	@echo "Fecha:      $(BUILD_DATE)"
	@echo "Imagen:     $(IMAGE_TAG)"
	@echo "DB URL:     $(DB_URL)"
	@echo "Log level:  $(LOG_LEVEL)"

## build: construye la imagen de la aplicación
build:
	@echo "[build] Construyendo $(APP_NAME):$(VERSION)-$(ENV)..."
	@echo "[build] Compilación OK."
	@echo "[build] Imagen lista: $(IMAGE_TAG)"

## test: ejecuta la suite de pruebas
test:
	@echo "[test] Ejecutando suite de pruebas en entorno: $(ENV)"
	@echo "[test] Tests OK."

## deploy: construye, prueba y despliega en el entorno configurado
deploy: build test
	@echo "[deploy] Desplegando en $(ENV)..."
	@echo "[deploy]   Imagen: $(IMAGE_TAG)"
	@echo "[deploy]   DB:     $(DB_URL)"
	@echo "[deploy] Deploy OK."

## clean: elimina artefactos de build
clean:
	@echo "[clean] Limpiando artefactos..."
	@rm -rf dist/
	@echo "[clean] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
