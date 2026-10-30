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

backend/$(VENV)/.installed: backend/requirements.txt
	@echo "[backend] Instalando dependencias..."
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r backend/requirements.txt
	@touch $@

backend-install: backend/$(VENV)/.installed ## Instalar dependencias del backend Python

backend-test: backend-install ## Ejecutar tests del backend
	@echo "[backend] Ejecutando tests..."
	cd backend && ../$(PYTEST) tests/ -v

frontend/node_modules/.package-lock.json: frontend/package.json
	@echo "[frontend] Instalando dependencias..."
	cd frontend && $(NPM) install
	@touch frontend/node_modules/.package-lock.json

frontend-install: frontend/node_modules/.package-lock.json ## Instalar dependencias del frontend Node.js

frontend-test: frontend-install ## Ejecutar tests del frontend
	@echo "[frontend] Ejecutando tests..."
	cd frontend && node tests/test.js

install: backend-install frontend-install ## Instalar todas las dependencias

test: backend-test frontend-test ## Ejecutar todos los tests

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
