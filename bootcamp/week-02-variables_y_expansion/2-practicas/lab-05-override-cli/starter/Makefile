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

# ── Flags de build ────────────────────────────────────────────
# TODO (paso 7): define BUILD_FLAGS con ?= y valor vacío, y en la línea
#       siguiente añade --pull con += de forma que se aplique aunque
#       BUILD_FLAGS llegue por la línea de comandos (pista: override)

info: ## muestra la configuración actual del build
	@echo "Configuración de build:"
	# TODO: @echo "  ENV:       $(ENV)"
	# TODO: @echo "  VERSION:   $(VERSION)"
	# TODO: @echo "  REGISTRY:  $(REGISTRY)"
	# TODO: @echo "  IMAGE_TAG: $(IMAGE_TAG)"
	# TODO (paso 6): una línea "  Origen de ENV: " con el resultado de la función origin

build: ## simula la construcción de la imagen
	@echo "Construyendo imagen..."
	# TODO: @echo "  Tag: $(IMAGE_TAG)"
	# TODO (paso 7): una línea "  Flags: " con BUILD_FLAGS
	@echo "Build OK."

deploy: build ## despliega la imagen en el entorno configurado
	@echo "Desplegando en entorno: $(ENV)"
	# TODO: @echo "  Imagen: $(IMAGE_TAG)"
	@echo "Deploy OK."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
