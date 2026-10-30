# Build system de mi-servicio. Dejó de funcionar después de que tres personas
# lo tocaran la misma semana. Tiene 5 errores: encuéntralos con las
# herramientas de diagnóstico de Make antes de mirar la solución.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build lint test docs ci deploy release clean help
.DEFAULT_GOAL := help

APP_NAME  := mi-servicio
BUILD_DIR := build
VERSION   := 1.0.0
IMAGE     := $(APP_NAME):$(VERSION)
TIMESTAMP = $(shell date +%Y%m%d-%H%M%S)

all: build docs ## Construir servicio y documentación

lint: ## Verificar estilo del código
	@echo "==> Lint OK"

build: lint ## Compilar el servicio
	@echo "==> Compilando $(APP_NAME) $(VERSION) ..."
	@mkdir -p $(BUILD_DIR)
	@echo "$(VERSION)" > $(BUILD_DIR)/version.txt
	@echo "$(TIMESTAMP)" > $(BUILD_DIR)/timestamp.txt
	@sleep 1
	@echo "✓ Build OK"

test: ## Ejecutar tests contra el artefacto
	@v=$$(cat $(BUILD_DIR)/version.txt); echo "==> Tests con build $$v"

docs: ## Generar la documentación (sub-make en docs/)
	@make -C docs

ci: lint test build ## Pipeline CI

deploy: build ## Desplegar el artefacto recién construido
    @echo "==> Desplegando $(IMAGE) del build $(TIMESTAMP)"
    @test "$$(cat $(BUILD_DIR)/timestamp.txt)" = "$(TIMESTAMP)" || { echo "✗ El artefacto no es el de este build"; exit 1; }
    @echo "✓ Deploy OK"

clean: ## Eliminar artefactos
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
