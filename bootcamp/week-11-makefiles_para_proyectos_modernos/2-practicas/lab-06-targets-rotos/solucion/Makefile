# Makefile del servicio "pedidos", con los seis bugs corregidos.
# No necesita uv ni Docker: la instalación y la imagen están simuladas con echo.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# FIX 2: build no produce un archivo llamado "build" sino un directorio con
# cosas dentro. Sin .PHONY, en cuanto build/ existe Make lo da por hecho.
.PHONY: all build install tag release release-build release-label env-check clean demo help
.DEFAULT_GOAL := help

APP_NAME    := pedidos
VENV        := .venv
BUILD_DIR   := build
# FIX 3: sin tag exacto, git describe falla y VERSION quedaba vacía
# ("pedidos:" no es una etiqueta válida). Fallback al hash corto o a 0.0.0.
VERSION     := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)
# FIX 6: ':=' evalúa date una sola vez. Con '=' cada uso lanzaba otro date
# y dos pasos del mismo release llevaban horas distintas.
BUILD_DATE  := $(shell date -u +%H:%M:%S)
IMAGE       := $(APP_NAME):$(VERSION)

# Configuración local de la app (en un proyecto real vendría de .env)
LOG_LEVEL   := INFO
DB_PASSWORD := s3cr3t-local

# FIX 5: solo lo que la app necesita. `export` a secas mandaba también
# DB_PASSWORD (y cualquier otra variable) al entorno de cada receta.
export LOG_LEVEL

build: ## Generar el artefacto en build/
	@mkdir -p $(BUILD_DIR)
	@echo "$(IMAGE)" > $(BUILD_DIR)/artefacto.txt
	@echo "Build OK: $(BUILD_DIR)/artefacto.txt"

# FIX 1: la receta empezaba con espacios (missing separator); ahora TAB.
# FIX 4: el sentinel depende también de uv.lock. Si solo cambia el lock
# (uv lock --upgrade de un compañero), hay que reinstalar.
$(VENV)/.installed: pyproject.toml uv.lock
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
