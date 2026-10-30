SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install test backend-install backend-test frontend-install frontend-test clean info help
.DEFAULT_GOAL := help

# ── Backend Python ──────────────────────────────────────────────────────────────
UV       := uv
VENV     := backend/.venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN      := $(UV) run --no-sync
PYTEST   := $(RUN) pytest

# ── Frontend Node.js ────────────────────────────────────────────────────────────
PNPM     := pnpm
NODE_MOD := frontend/node_modules

# ── Docker ─────────────────────────────────────────────────────────────────────
# Compose v2, integrado en Docker. docker-compose (v1) está en EOL desde 2023.
COMPOSE  := docker compose

$(VENV)/.installed: backend/pyproject.toml backend/uv.lock
	@echo "[backend] Instalando dependencias..."
	cd backend && $(UV) sync --locked
	@touch $@

backend-install: $(VENV)/.installed ## Instalar dependencias del backend Python

backend-test: backend-install ## Ejecutar tests del backend
	@echo "[backend] Ejecutando tests..."
	cd backend && $(PYTEST) tests/ -v

frontend/node_modules/.installed: frontend/package.json frontend/pnpm-lock.yaml
	@echo "[frontend] Instalando dependencias..."
	cd frontend && $(PNPM) install --frozen-lockfile
	@mkdir -p $(@D)
	@touch $@

frontend-install: frontend/node_modules/.installed ## Instalar dependencias del frontend Node.js

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
	@echo "Backend:   $(shell $(UV) --version 2>&1) — backend/"
	@echo "Frontend:  Node.js $(shell node --version 2>/dev/null || echo 'no instalado') — frontend/"
	@echo "Docker:    $(COMPOSE) disponible"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
