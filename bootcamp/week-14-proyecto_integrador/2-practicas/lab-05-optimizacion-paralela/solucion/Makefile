SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help
.DEFAULT_GOAL := help

DIST_DIR   := dist
STAMPS_DIR := .stamps

$(STAMPS_DIR)/:
	mkdir -p $@

# Las instalaciones se simulan con sleep para que el lab no necesite red. En
# un proyecto real la receta sería `uv sync --locked` y
# `pnpm install --frozen-lockfile`: el stamp depende de los mismos archivos.
$(STAMPS_DIR)/deps-python: pyproject.toml uv.lock | $(STAMPS_DIR)/
	@echo "==> Instalando deps Python ..."
	@sleep 1
	touch $@

$(STAMPS_DIR)/deps-node: package.json pnpm-lock.yaml | $(STAMPS_DIR)/
	@echo "==> Instalando deps Node ..."
	@sleep 1
	touch $@

$(DIST_DIR)/backend.out: $(STAMPS_DIR)/deps-python | $(DIST_DIR)/
	@echo "==> Compilando backend ..."
	@echo "backend-compiled" > $@
	@echo "✓ Backend listo"

$(DIST_DIR)/frontend.out: $(STAMPS_DIR)/deps-node | $(DIST_DIR)/
	@echo "==> Compilando frontend ..."
	@echo "frontend-compiled" > $@
	@echo "✓ Frontend listo"

$(DIST_DIR)/:
	mkdir -p $@

build-backend: $(DIST_DIR)/backend.out ## Construir backend (Python)

build-frontend: $(DIST_DIR)/frontend.out ## Construir frontend (Node.js)

all: build-backend build-frontend ## Construir backend y frontend (paralelizable con -j)

clean: ## Eliminar artefactos y stamps
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	$(if $(STAMPS_DIR),,$(error STAMPS_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(DIST_DIR)' '$(STAMPS_DIR)'

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
