.PHONY: all build-backend build-frontend clean help
.DEFAULT_GOAL := help

DIST_DIR := dist

# Problema: este Makefile no usa stamps — reconstruye todo en cada ejecución
# Objetivo: convertirlo a un build inteligente con stamps y paralelismo correcto

all: build-backend build-frontend ## Construir backend y frontend

# TODO: convertir en target con stamp .stamps/deps-python
# Dependencia real: requirements.txt
# Acción: pip install -r requirements.txt -q && sleep 1 (simula instalación lenta)
build-backend: ## Construir backend (Python)
	@echo "==> Instalando deps Python ..."
	@sleep 1
	@echo "==> Compilando backend ..."
	@mkdir -p $(DIST_DIR)
	@echo "backend-compiled" > $(DIST_DIR)/backend.out
	@echo "✓ Backend listo"

# TODO: convertir en target con stamp .stamps/deps-node
# Dependencia real: package.json
# Acción: npm install --silent && sleep 1 (simula instalación lenta)
build-frontend: ## Construir frontend (Node.js)
	@echo "==> Instalando deps Node ..."
	@sleep 1
	@echo "==> Compilando frontend ..."
	@mkdir -p $(DIST_DIR)
	@echo "frontend-compiled" > $(DIST_DIR)/frontend.out
	@echo "✓ Frontend listo"

# TODO: crear archivos vacíos requirements.txt y package.json para que Make pueda rastrear cambios
# (ya existen en el starter — no los borres)

clean: ## Eliminar artefactos y stamps
	rm -rf $(DIST_DIR)
	# TODO: también eliminar el directorio .stamps/

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
