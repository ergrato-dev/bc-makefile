# Makefile heredado del servicio "pedidos". Funciona... a veces.
# No necesita uv ni Docker: la instalación y la imagen están simuladas con echo.
# Tiene seis bugs. Reprodúcelos antes de corregirlos (ver README).

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install tag release env-check clean demo help
.DEFAULT_GOAL := help

APP_NAME    := pedidos
VENV        := .venv
BUILD_DIR   := build
VERSION     := $(shell git describe --tags --exact-match 2>/dev/null)
BUILD_DATE   = $(shell date -u +%H:%M:%S)
IMAGE       := $(APP_NAME):$(VERSION)

# Configuración local de la app (en un proyecto real vendría de .env)
LOG_LEVEL   := INFO
DB_PASSWORD := s3cr3t-local

export

build: ## Generar el artefacto en build/
	@mkdir -p $(BUILD_DIR)
	@echo "$(IMAGE)" > $(BUILD_DIR)/artefacto.txt
	@echo "Build OK: $(BUILD_DIR)/artefacto.txt"

$(VENV)/.installed: pyproject.toml
    @echo "uv sync --locked  (simulado)"
	@mkdir -p $(@D)
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias (simulado)

tag: ## Mostrar la etiqueta de la imagen
	@echo "Imagen: $(IMAGE)"

# release simula dos pasos de un despliegue que tardan un poco cada uno
release: release-build release-label ## Simular build + etiquetado de la imagen

release-build:
	@echo "docker build --build-arg BUILD_DATE=$(BUILD_DATE) -t $(IMAGE) ."
	@sleep 1

release-label:
	@echo "Etiqueta org.opencontainers.image.created=$(BUILD_DATE)"

env-check: ## Mostrar qué variables de configuración ve una receta
	@env | grep -E '^(LOG_LEVEL|DB_PASSWORD)=' | sort || true

clean: ## Eliminar artefactos
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD_DIR)' '$(VENV)'
	@echo "Limpiado."

demo: build install tag release env-check ## Ejecutar todo de una vez

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
