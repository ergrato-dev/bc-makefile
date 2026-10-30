.PHONY: lint test build report ci clean help
.DEFAULT_GOAL := help

UV       := uv
VENV     := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN      := $(UV) run --no-sync
PYTEST   := $(RUN) pytest
FLAKE8   := $(RUN) flake8
APP_NAME := calculadora
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)
DIST_DIR := dist
SRC_DIR  := src
TEST_DIR := tests

$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked --quiet
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias

# --------------------------------------------------------------------------
# TODO 1: Implementa el target lint.
#         Debe ejecutar flake8 sobre SRC_DIR.
#         Si hay errores de estilo, Make debe abortar.
# --------------------------------------------------------------------------
lint: install ## Verificar estilo de código con flake8
	# TODO: ejecutar $(FLAKE8) sobre $(SRC_DIR)

# --------------------------------------------------------------------------
# TODO 2: Implementa el target test.
#         Debe ejecutar pytest con cobertura sobre TEST_DIR.
#         Usa --cov=$(SRC_DIR) --cov-report=term-missing
# --------------------------------------------------------------------------
test: install ## Ejecutar tests con cobertura
	# TODO: ejecutar $(PYTEST) con argumentos de cobertura

# --------------------------------------------------------------------------
# TODO 3: Implementa el target build.
#         Debe crear DIST_DIR si no existe y generar
#         dist/APP_NAME-VERSION.tar.gz con los archivos de SRC_DIR.
# --------------------------------------------------------------------------
build: ## Construir artefacto de distribución
	# TODO: crear dist/ y tar.gz con src/

# --------------------------------------------------------------------------
# TODO 4: Implementa el target report.
#         Debe imprimir un resumen: app, versión, fecha, y confirmación de
#         que lint, test y build pasaron.
# --------------------------------------------------------------------------
report: ## Imprimir resumen del pipeline
	@echo "==================================="
	@echo "  Pipeline Report"
	@echo "==================================="
	# TODO: imprimir APP_NAME, VERSION, fecha, y estado de etapas

# --------------------------------------------------------------------------
# TODO 5: Implementa el target ci que encadena: lint → test → build → report
#         Al terminar imprime: "✓ CI OK"
# --------------------------------------------------------------------------
ci: ## Ejecutar pipeline completo (lint → test → build → report)
	# TODO: encadenar dependencias
	@echo "✓ CI OK"

clean: ## Eliminar artefactos
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' '$(DIST_DIR)' __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
