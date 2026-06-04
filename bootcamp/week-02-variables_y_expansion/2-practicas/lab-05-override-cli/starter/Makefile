# ============================================================
# Lab 05 — Override desde CLI
# Semana 02: Variables y Expansión en Make
# ============================================================
# Escenarios a probar:
#   make info
#   make info ENV=staging VERSION=1.0.0
#   make build ENV=prod VERSION=2.0.0 REGISTRY=hub.docker.com
#   make deploy ENV=prod VERSION=2.0.0
# ============================================================

.PHONY: info build deploy help

.DEFAULT_GOAL := help

# ── Configuración del build ───────────────────────────────────
# TODO: define ENV con ?= y valor "dev"
# ENV ?= ...

# TODO: define VERSION con ?= y valor "0.1.0"
# VERSION ?= ...

# TODO: define REGISTRY con ?= y valor "registry.local"
# REGISTRY ?= ...

# TODO: define APP_NAME con ?= y valor "myapp"
# APP_NAME ?= ...

# TODO: define IMAGE_TAG con = (no :=) construyendo:
#       "$(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)"
#       Usa = para que los overrides CLI de ENV/VERSION se propaguen
# IMAGE_TAG = ...

## info: muestra la configuración actual del build
info:
	@echo "Configuración de build:"
	# TODO: @echo "  ENV:       $(ENV)"
	# TODO: @echo "  VERSION:   $(VERSION)"
	# TODO: @echo "  REGISTRY:  $(REGISTRY)"
	# TODO: @echo "  IMAGE_TAG: $(IMAGE_TAG)"

## build: simula la construcción de la imagen
build:
	@echo "Construyendo imagen..."
	# TODO: @echo "  Tag: $(IMAGE_TAG)"
	@echo "Build OK."

## deploy: despliega la imagen en el entorno configurado
deploy: build
	@echo "Desplegando en entorno: $(ENV)"
	# TODO: @echo "  Imagen: $(IMAGE_TAG)"
	@echo "Deploy OK."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
