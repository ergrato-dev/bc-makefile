.PHONY: all build-backend build-frontend clean help
.DEFAULT_GOAL := help

DIST_DIR := dist

# Problema: este Makefile no usa stamps — reconstruye todo en cada ejecución
# Objetivo: convertirlo a un build inteligente con stamps y paralelismo correcto

all: build-backend build-frontend ## Construir backend y frontend

# TODO: convertir en target con stamp .stamps/deps-python
# Dependencias reales: pyproject.toml uv.lock
# Acción simulada: sleep 1 (en un proyecto real, uv sync --locked)
build-backend: ## Construir backend (Python)
	@echo "==> Instalando deps Python ..."
	@sleep 1
	@echo "==> Compilando backend ..."
	@mkdir -p $(DIST_DIR)
	@echo "backend-compiled" > $(DIST_DIR)/backend.out
	@echo "✓ Backend listo"

# TODO: convertir en target con stamp .stamps/deps-node
# Dependencias reales: package.json pnpm-lock.yaml
# Acción simulada: sleep 1 (en un proyecto real, pnpm install --frozen-lockfile)
build-frontend: ## Construir frontend (Node.js)
	@echo "==> Instalando deps Node ..."
	@sleep 1
	@echo "==> Compilando frontend ..."
	@mkdir -p $(DIST_DIR)
	@echo "frontend-compiled" > $(DIST_DIR)/frontend.out
	@echo "✓ Frontend listo"

# pyproject.toml, uv.lock, package.json y pnpm-lock.yaml ya existen en el
# starter: son los archivos cuya fecha compara Make. No los borres.

clean: ## Eliminar artefactos y stamps
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(DIST_DIR)'
	# TODO: también eliminar el directorio .stamps/

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
