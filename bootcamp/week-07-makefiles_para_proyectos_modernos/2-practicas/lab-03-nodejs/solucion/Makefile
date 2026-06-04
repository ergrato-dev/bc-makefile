.PHONY: all install build test lint clean help
.DEFAULT_GOAL := help

NPM      := npm
NODE     := node
SRC_DIR  := src
DIST_DIR := dist

node_modules/.package-lock.json: package.json
	$(NPM) install
	@touch $@

install: node_modules/.package-lock.json ## Instalar dependencias Node.js

build: install ## Compilar el proyecto
	$(NPM) run build

test: install ## Ejecutar tests
	$(NPM) test

lint: install ## Verificar estilo de código
	$(NPM) run lint

clean: ## Eliminar node_modules y dist
	@rm -rf node_modules $(DIST_DIR)
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
