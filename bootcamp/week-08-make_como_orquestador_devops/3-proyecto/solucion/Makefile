.PHONY: env-check install hooks-install hooks-uninstall hooks-status \
        lint test build report ci version bump-patch clean help
.DEFAULT_GOAL := help

PYTHON       := python3
VENV         := .venv
PIP          := $(VENV)/bin/pip
PYTEST       := $(VENV)/bin/pytest
FLAKE8       := $(VENV)/bin/flake8
APP_NAME     := mi-api
VERSION_FILE := VERSION
VERSION      := $(shell cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0")
MAJOR        := $(shell echo $(VERSION) | cut -d. -f1)
MINOR        := $(shell echo $(VERSION) | cut -d. -f2)
PATCH        := $(shell echo $(VERSION) | cut -d. -f3)
DIST         := dist
SRC          := src
TESTS        := tests
HOOKS_SRC    := scripts/hooks
HOOKS_DIR    := .git/hooks
HOOKS        := pre-commit pre-push
DATE         := $(shell date '+%Y-%m-%d %H:%M:%S')

-include .env
export

guard-%:
	@test -n "${$*}" || \
		(echo "ERROR: $* no definida. Copia .env.example → .env y asigna un valor"; exit 1)

env-check: guard-APP_NAME guard-DB_URL guard-SECRET_KEY guard-ENV ## Verificar variables de entorno requeridas
	@echo "Variables de entorno OK"

$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip -q
	$(PIP) install -r requirements.txt -q
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias Python

hooks-install: ## Instalar git hooks
	@mkdir -p $(HOOKS_DIR)
	@$(foreach hook,$(HOOKS), \
		cp $(HOOKS_SRC)/$(hook) $(HOOKS_DIR)/$(hook) && \
		chmod +x $(HOOKS_DIR)/$(hook) && \
		echo "  Instalado: $(hook)";)
	@echo "Hooks instalados."

hooks-uninstall: ## Desinstalar git hooks
	@$(foreach hook,$(HOOKS), \
		rm -f $(HOOKS_DIR)/$(hook) && \
		echo "  Eliminado: $(hook)";)
	@echo "Hooks desinstalados."

hooks-status: ## Ver estado de los git hooks
	@echo "=== Estado de git hooks ==="
	@$(foreach hook,$(HOOKS), \
		printf "  %-15s" "$(hook)"; \
		if [ -f "$(HOOKS_DIR)/$(hook)" ]; then \
			printf "✓ instalado  "; \
			if [ -x "$(HOOKS_DIR)/$(hook)" ]; then echo "✓ ejecutable"; else echo "✗ no ejecutable"; fi; \
		else \
			echo "✗ no instalado"; \
		fi;)

lint: install ## Verificar estilo de código
	@echo "→ Lint..."
	$(FLAKE8) $(SRC)
	@echo "✓ Lint OK"

test: install ## Ejecutar tests con cobertura
	@echo "→ Tests..."
	$(PYTEST) $(TESTS) -v --cov=$(SRC) --cov-report=term-missing
	@echo "✓ Tests OK"

build: ## Construir artefacto
	@echo "→ Build..."
	@mkdir -p $(DIST)
	@tar -czf $(DIST)/$(APP_NAME)-$(VERSION).tar.gz $(SRC)/
	@echo "✓ Build OK → $(DIST)/$(APP_NAME)-$(VERSION).tar.gz"

report: ## Imprimir resumen del pipeline
	@echo "======================================="
	@echo "  Pipeline Report"
	@echo "======================================="
	@echo "  App:     $(APP_NAME)"
	@echo "  Versión: $(VERSION)"
	@echo "  Entorno: $(ENV)"
	@echo "  Fecha:   $(DATE)"
	@echo "---------------------------------------"
	@echo "  ✓ env-check  OK"
	@echo "  ✓ lint       OK"
	@echo "  ✓ test       OK"
	@echo "  ✓ build      OK → $(DIST)/$(APP_NAME)-$(VERSION).tar.gz"
	@echo "======================================="

ci: env-check lint test build report ## Pipeline completo (env-check → lint → test → build → report)
	@echo "✓ CI OK"

version: ## Mostrar versión actual
	@echo "Versión actual: $(VERSION)"

bump-patch: ## Incrementar versión patch
	$(eval NEW_PATCH := $(shell expr $(PATCH) + 1))
	$(eval NEW_VERSION := $(MAJOR).$(MINOR).$(NEW_PATCH))
	@echo $(NEW_VERSION) > $(VERSION_FILE)
	@echo "Nueva versión: $(NEW_VERSION)"

clean: ## Eliminar artefactos
	@rm -rf $(VENV) $(DIST) __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
