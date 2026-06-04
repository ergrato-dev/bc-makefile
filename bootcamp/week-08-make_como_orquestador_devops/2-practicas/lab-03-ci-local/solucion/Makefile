.PHONY: lint test build report ci ci-fast clean help
.DEFAULT_GOAL := help

PYTHON   := python3
VENV     := .venv
PIP      := $(VENV)/bin/pip
PYTEST   := $(VENV)/bin/pytest
FLAKE8   := $(VENV)/bin/flake8
APP_NAME := calculadora
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)
DIST_DIR := dist
SRC_DIR  := src
TEST_DIR := tests
DATE     := $(shell date '+%Y-%m-%d %H:%M:%S')

$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip -q
	$(PIP) install -r requirements.txt -q
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias

lint: install ## Verificar estilo de código con flake8
	@echo "→ Lint..."
	$(FLAKE8) $(SRC_DIR)
	@echo "✓ Lint OK"

test: install ## Ejecutar tests con cobertura
	@echo "→ Tests..."
	$(PYTEST) $(TEST_DIR) -v --cov=$(SRC_DIR) --cov-report=term-missing
	@echo "✓ Tests OK"

build: ## Construir artefacto de distribución
	@echo "→ Build..."
	@mkdir -p $(DIST_DIR)
	@tar -czf $(DIST_DIR)/$(APP_NAME)-$(VERSION).tar.gz $(SRC_DIR)/
	@echo "✓ Build OK → $(DIST_DIR)/$(APP_NAME)-$(VERSION).tar.gz"

report: ## Imprimir resumen del pipeline
	@echo "==================================="
	@echo "  Pipeline Report"
	@echo "==================================="
	@echo "  App:     $(APP_NAME)"
	@echo "  Versión: $(VERSION)"
	@echo "  Fecha:   $(DATE)"
	@echo "-----------------------------------"
	@echo "  ✓ lint   OK"
	@echo "  ✓ test   OK"
	@echo "  ✓ build  OK → $(DIST_DIR)/$(APP_NAME)-$(VERSION).tar.gz"
	@echo "==================================="

ci: lint test build report ## Ejecutar pipeline completo (lint → test → build → report)
	@echo "✓ CI OK"

ci-fast: lint test ## Pipeline rápido (solo lint + test, sin build)
	@echo "✓ CI-fast OK"

clean: ## Eliminar artefactos
	@rm -rf $(VENV) $(DIST_DIR) __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
