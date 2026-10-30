SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install test lint backend-install backend-test backend-lint backend-format frontend-install frontend-test frontend-lint clean info help
.DEFAULT_GOAL := help

# ── Backend Python ──────────────────────────────────────────────────────────────
UV       := uv
VENV     := backend/.venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN      := $(UV) run --no-sync
PYTEST   := $(RUN) pytest
RUFF     := $(RUN) ruff

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

backend-lint: backend-install ## Analizar el backend con ruff check
	@echo "[backend] Lint..."
	cd backend && $(RUFF) check src/

backend-format: backend-install ## Reformatear el backend con ruff format
	@echo "[backend] Formateando..."
	cd backend && $(RUFF) format src/ tests/

frontend-lint: frontend-install ## Lint del frontend
	@echo "[frontend] Lint..."
	cd frontend && $(PNPM) run lint

install: backend-install frontend-install ## Instalar todas las dependencias

test: backend-test frontend-test ## Ejecutar todos los tests

lint: backend-lint frontend-lint ## Lint de los dos stacks

clean: ## Eliminar artefactos de backend y frontend
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	$(if $(NODE_MOD),,$(error NODE_MOD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' backend/src/__pycache__ backend/tests/__pycache__ backend/.pytest_cache backend/.ruff_cache
	@rm -rf -- '$(NODE_MOD)'
	@echo "Limpiado."

info: ## Mostrar información del stack
	@echo "=== Stack multi-lenguaje ==="
	@echo "Backend:   $(shell $(UV) --version 2>&1) — backend/"
	@echo "Frontend:  Node.js $(shell node --version 2>/dev/null || echo 'no instalado') — frontend/"
	@echo "Docker:    $(COMPOSE) disponible"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
