SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install build test lint clean help
.DEFAULT_GOAL := help

PNPM     := pnpm
NODE     := node
SRC_DIR  := src
DIST_DIR := dist

# --frozen-lockfile instala exactamente lo que dice pnpm-lock.yaml y falla
# si no coincide con package.json. El sentinel es nuestro: no dependemos
# de archivos internos del gestor de paquetes.
node_modules/.installed: package.json pnpm-lock.yaml
	$(PNPM) install --frozen-lockfile
	@mkdir -p $(@D)
	@touch $@

install: node_modules/.installed ## Instalar dependencias Node.js

# dist/index.js es un archivo real: Make solo recompila si cambia el fuente
# o se reinstalan las dependencias (el sentinel es más nuevo).
$(DIST_DIR)/index.js: $(SRC_DIR)/index.js node_modules/.installed
	$(PNPM) run build

build: $(DIST_DIR)/index.js ## Compilar el proyecto (incremental)

test: install ## Ejecutar tests
	$(PNPM) test

lint: install ## Verificar estilo de código
	$(PNPM) run lint

clean: ## Eliminar node_modules y dist
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- node_modules '$(DIST_DIR)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
