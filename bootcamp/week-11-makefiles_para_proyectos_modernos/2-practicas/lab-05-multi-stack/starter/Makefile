.PHONY: all install test backend-install backend-test frontend-install frontend-test clean info help
.DEFAULT_GOAL := help

# ── Backend Python ──────────────────────────────────────────────────────────────
PYTHON   := python3
VENV     := backend/.venv
PIP      := $(VENV)/bin/pip
PYTEST   := $(VENV)/bin/pytest

# ── Frontend Node.js ────────────────────────────────────────────────────────────
NPM      := npm
NODE_MOD := frontend/node_modules

# ── Docker ─────────────────────────────────────────────────────────────────────
COMPOSE  := $(shell docker compose version > /dev/null 2>&1 && echo "docker compose" || echo "docker-compose")

# TODO 1: Define el target 'backend/$(VENV)/.installed' con dependencia backend/requirements.txt
#   Receta: $(PYTHON) -m venv $(VENV) && $(PIP) install -r backend/requirements.txt && touch $@
#   Antes de instalar, imprime "@echo '[backend] Instalando dependencias...'"


# TODO 2: Define 'backend-install' como alias del sentinel


# TODO 3: Define 'backend-test' que dependa de backend-install y ejecute:
#   @echo "[backend] Ejecutando tests..."
#   cd backend && ../$(PYTEST) tests/ -v


# TODO 4: Define el target 'frontend/node_modules/.package-lock.json' con dependencia frontend/package.json
#   Receta: cd frontend && $(NPM) install && touch .package-lock.json
#   (npm install no genera .package-lock.json directamente dentro de node_modules/ en todos los sistemas)
#   Alternativa más robusta: cd frontend && $(NPM) install && touch node_modules/.package-lock.json


# TODO 5: Define 'frontend-install' como alias del sentinel


# TODO 6: Define 'frontend-test' que dependa de frontend-install y ejecute:
#   @echo "[frontend] Ejecutando tests..."
#   cd frontend && node tests/test.js


# TODO 7: Define 'install' que dependa de backend-install y frontend-install


# TODO 8: Define 'test' que dependa de backend-test y frontend-test


clean: ## Eliminar artefactos de backend y frontend
	@rm -rf backend/.venv backend/__pycache__ backend/tests/__pycache__ backend/.pytest_cache
	@rm -rf frontend/node_modules
	@echo "Limpiado."

info: ## Mostrar información del stack
	@echo "=== Stack multi-lenguaje ==="
	@echo "Backend:   $(shell $(PYTHON) --version 2>&1) — backend/"
	@echo "Frontend:  Node.js $(shell node --version 2>/dev/null || echo 'no instalado') — frontend/"
	@echo "Docker:    $(COMPOSE) disponible"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
