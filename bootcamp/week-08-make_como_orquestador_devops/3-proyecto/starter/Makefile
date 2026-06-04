.PHONY: env-check install hooks-install hooks-uninstall hooks-status \
        lint test build report ci version bump-patch clean help
.DEFAULT_GOAL := help

# ---------------------------------------------------------------------------
# Variables — completa las que falten
# ---------------------------------------------------------------------------
PYTHON      := python3
VENV        := .venv
PIP         := $(VENV)/bin/pip
PYTEST      := $(VENV)/bin/pytest
FLAKE8      := $(VENV)/bin/flake8
APP_NAME    := mi-api
VERSION_FILE := VERSION
VERSION     := $(shell cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0")
MAJOR       := $(shell echo $(VERSION) | cut -d. -f1)
MINOR       := $(shell echo $(VERSION) | cut -d. -f2)
PATCH       := $(shell echo $(VERSION) | cut -d. -f3)
DIST        := dist
SRC         := src
TESTS       := tests
HOOKS_SRC   := scripts/hooks
HOOKS_DIR   := .git/hooks
HOOKS       := pre-commit pre-push
DATE        := $(shell date '+%Y-%m-%d %H:%M:%S')

-include .env
export

# ---------------------------------------------------------------------------
# TODO 1: guard-% — valida variables requeridas
# ---------------------------------------------------------------------------
guard-%:
	# TODO: implementar

# ---------------------------------------------------------------------------
# TODO 2: env-check — valida APP_NAME, DB_URL, SECRET_KEY, ENV
# ---------------------------------------------------------------------------
env-check: ## Verificar variables de entorno requeridas
	# TODO: usar guard-% para cada variable
	@echo "Variables de entorno OK"

# ---------------------------------------------------------------------------
# TODO 3: install — instala dependencias con sentinel file
# ---------------------------------------------------------------------------
$(VENV)/.installed: requirements.txt
	# TODO: crear venv, instalar deps, touch sentinel

install: $(VENV)/.installed ## Instalar dependencias Python

# ---------------------------------------------------------------------------
# TODO 4: hooks-install, hooks-uninstall, hooks-status
# ---------------------------------------------------------------------------
hooks-install: ## Instalar git hooks
	# TODO: copiar HOOKS_SRC/* a HOOKS_DIR con chmod +x

hooks-uninstall: ## Desinstalar git hooks
	# TODO: eliminar hooks de HOOKS_DIR

hooks-status: ## Ver estado de los git hooks
	# TODO: mostrar tabla de estado

# ---------------------------------------------------------------------------
# TODO 5: lint — ejecuta flake8 sobre SRC
# ---------------------------------------------------------------------------
lint: install ## Verificar estilo de código
	# TODO: ejecutar flake8

# ---------------------------------------------------------------------------
# TODO 6: test — ejecuta pytest con cobertura
# ---------------------------------------------------------------------------
test: install ## Ejecutar tests con cobertura
	# TODO: ejecutar pytest --cov

# ---------------------------------------------------------------------------
# TODO 7: build — crea dist/APP_NAME-VERSION.tar.gz
# ---------------------------------------------------------------------------
build: ## Construir artefacto
	# TODO: crear dist/ y tar.gz

# ---------------------------------------------------------------------------
# TODO 8: report — imprime resumen del pipeline
# ---------------------------------------------------------------------------
report: ## Imprimir resumen del pipeline
	# TODO: imprimir tabla de resultados

# ---------------------------------------------------------------------------
# TODO 9: ci — orquesta env-check → lint → test → build → report
# ---------------------------------------------------------------------------
ci: ## Pipeline completo
	# TODO: encadenar dependencias
	@echo "✓ CI OK"

# ---------------------------------------------------------------------------
# TODO 10: version y bump-patch
# ---------------------------------------------------------------------------
version: ## Mostrar versión actual
	@echo "Versión actual: $(VERSION)"

bump-patch: ## Incrementar versión patch
	# TODO: incrementar PATCH y escribir a VERSION_FILE

# ---------------------------------------------------------------------------
clean: ## Eliminar artefactos
	@rm -rf $(VENV) $(DIST) __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
