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

# ── Flags de build ────────────────────────────────────────────
# El usuario puede pasar BUILD_FLAGS, pero --pull es obligatorio:
# sin override, el += se ignoraría cuando BUILD_FLAGS llega por la CLI
BUILD_FLAGS ?=
override BUILD_FLAGS += --pull

info: ## muestra la configuración actual del build
	@echo "Configuración de build:"
	@echo "  ENV:       $(ENV)"
	@echo "  VERSION:   $(VERSION)"
	@echo "  REGISTRY:  $(REGISTRY)"
	@echo "  IMAGE_TAG: $(IMAGE_TAG)"
	@echo "  Origen de ENV: $(origin ENV)"

build: ## simula la construcción de la imagen
	@echo "Construyendo imagen..."
	@echo "  Tag: $(IMAGE_TAG)"
	@echo "  Flags: $(BUILD_FLAGS)"
	@echo "Build OK."

deploy: build ## despliega la imagen en el entorno configurado
	@echo "Desplegando en entorno: $(ENV)"
	@echo "  Imagen: $(IMAGE_TAG)"
	@echo "Deploy OK."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
