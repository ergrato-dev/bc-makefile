# ============================================================
# Lab 05 — Override desde CLI (SOLUCIÓN)
# ============================================================

.PHONY: info build deploy help

.DEFAULT_GOAL := help

# ── Configuración del build ───────────────────────────────────
ENV      ?= dev
VERSION  ?= 0.1.0
REGISTRY ?= registry.local
APP_NAME ?= myapp

# = (no :=) para que ENV y VERSION del CLI se propaguen al tag
IMAGE_TAG = $(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)

## info: muestra la configuración actual del build
info:
	@echo "Configuración de build:"
	@echo "  ENV:       $(ENV)"
	@echo "  VERSION:   $(VERSION)"
	@echo "  REGISTRY:  $(REGISTRY)"
	@echo "  IMAGE_TAG: $(IMAGE_TAG)"

## build: simula la construcción de la imagen
build:
	@echo "Construyendo imagen..."
	@echo "  Tag: $(IMAGE_TAG)"
	@echo "Build OK."

## deploy: despliega la imagen en el entorno configurado
deploy: build
	@echo "Desplegando en entorno: $(ENV)"
	@echo "  Imagen: $(IMAGE_TAG)"
	@echo "Deploy OK."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
