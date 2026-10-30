SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build lint test ci deploy help
.DEFAULT_GOAL := help

APP_NAME  := mi-servicio
BUILD_DIR := build
VERSION   := 1.0.0
IMAGE     := $(APP_NAME):$(VERSION)

# FIX 1: := en lugar de = — TIMESTAMP se evalúa una vez al parsear,
# no en cada expansión (evita timestamps distintos por target)
TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)

# FIX 2: eliminado 'release' de .PHONY — no existe como target real;
# tenerlo en .PHONY sin target causa "No rule to make target 'release'"

all: build ## Construir el proyecto

# FIX 3: 'build' añadido a .PHONY — no debe crear un archivo llamado 'build';
# el archivo 'build' existente hacía que Make lo considerara siempre al día
build: lint ## Compilar el servicio
	@echo "==> Compilando $(APP_NAME) $(VERSION) ..."
	@mkdir -p $(BUILD_DIR)
	@echo "$(VERSION)" > $(BUILD_DIR)/version.txt
	@echo "✓ Build OK"

lint: ## Verificar estilo del código
	@echo "==> Lint OK"

# FIX 4: declarada dependencia explícita 'test: build' — test necesita
# que BUILD_DIR/version.txt exista; sin esta dependencia, con -j2 puede
# correr antes que build y leer un archivo inexistente
test: build ## Ejecutar tests
	@echo "==> Tests con build $(shell cat $(BUILD_DIR)/version.txt)"

# FIX 4 también: ci ahora es lint → build → test (orden correcto)
ci: lint build test ## Pipeline CI

# FIX 5: TABs correctos en la receta de deploy (los espacios causaban
# "missing separator" error en GNU Make)
deploy: ## Desplegar el servicio
	@echo "==> Desplegando $(IMAGE) ..."
	@echo "Timestamp: $(TIMESTAMP)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
