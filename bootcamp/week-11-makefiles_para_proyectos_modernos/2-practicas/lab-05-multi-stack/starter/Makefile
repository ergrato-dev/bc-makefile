.PHONY: all install test backend-install backend-test frontend-install frontend-test clean info help
.DEFAULT_GOAL := help

# ── Backend Python ──────────────────────────────────────────────────────────────
PYTHON   := python3
VENV     := backend/.venv
PIP      := $(VENV)/bin/pip
PYTEST   := $(VENV)/bin/python -m pytest

# ── Frontend Node.js ────────────────────────────────────────────────────────────
PNPM     := pnpm
NODE_MOD := frontend/node_modules

# ── Docker ─────────────────────────────────────────────────────────────────────
# Compose v2, integrado en Docker. docker-compose (v1) está en EOL desde 2023.
COMPOSE  := docker compose

# TODO 1: Define el target '$(VENV)/.installed' con dependencia backend/requirements.txt
#   Receta: $(PYTHON) -m venv $(VENV) && $(PIP) install -r backend/requirements.txt && touch $@
#   Antes de instalar, imprime "@echo '[backend] Instalando dependencias...'"


# TODO 2: Define 'backend-install' como alias del sentinel


# TODO 3: Define 'backend-test' que dependa de backend-install y ejecute:
#   @echo "[backend] Ejecutando tests..."
#   cd backend && ../$(PYTEST) tests/ -v


# TODO 4: Define el target 'frontend/node_modules/.installed' con dependencias
#         frontend/package.json y frontend/pnpm-lock.yaml
#   Receta: cd frontend && $(PNPM) install --frozen-lockfile
#           @mkdir -p $(@D)
#           @touch $@
#   (el mkdir asegura que node_modules/ exista aunque no haya dependencias)


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
