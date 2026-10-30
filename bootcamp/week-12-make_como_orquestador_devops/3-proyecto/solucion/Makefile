SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: env-check install hooks-install hooks-uninstall hooks-status \
        lint test build report ci version bump-patch clean help
.DEFAULT_GOAL := help

UV           := uv
VENV         := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN          := $(UV) run --no-sync
PYTEST       := $(RUN) pytest
FLAKE8       := $(RUN) flake8
APP_NAME     := mi-api
VERSION_FILE := VERSION
# VERSION viene de un archivo del repo: un PR puede cambiarlo. Se lee sin
# shell ($(file <)) y se valida antes de usarlo en ninguna receta.
VERSION      := $(strip $(or $(file < $(VERSION_FILE)),0.0.0))
VERSION_PARTS := $(subst ., ,$(VERSION))
# Quitar los dígitos debe dejar exactamente "..": solo dígitos y dos puntos.
VERSION_REST := $(subst 0,,$(subst 1,,$(subst 2,,$(subst 3,,$(subst 4,,$(subst 5,,$(subst 6,,$(subst 7,,$(subst 8,,$(subst 9,,$(VERSION)))))))))))
ifneq ($(VERSION_REST) $(words $(VERSION_PARTS)),.. 3)
  $(error VERSION inválida en $(VERSION_FILE). Formato esperado: MAYOR.MENOR.PARCHE)
endif
MAJOR        := $(word 1,$(VERSION_PARTS))
MINOR        := $(word 2,$(VERSION_PARTS))
PATCH        := $(word 3,$(VERSION_PARTS))
DIST         := dist
SRC          := src
TESTS        := tests
HOOKS_SRC    := scripts/hooks
HOOKS        := pre-commit pre-push
DATE         := $(shell date '+%Y-%m-%d %H:%M:%S')

# .env se parsea como Makefile: valores sin `$`, sin comillas y sin `#`.
-include .env
# Solo lo que necesitan los tests y la app; nunca `export` a secas.
export APP_NAME ENV DB_URL SECRET_KEY

guard-%:
	@$(if $($*),:,$(error $* no definida. Copia .env.example a .env y asigna un valor))

env-check: guard-APP_NAME guard-DB_URL guard-SECRET_KEY guard-ENV ## Verificar variables de entorno requeridas
	@echo "Variables de entorno OK"

$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked --quiet
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias Python

# core.hooksPath: git lee los hooks de scripts/hooks/ (versionado). Son una
# ayuda, no un control: `git commit --no-verify` los salta. El control que no
# se puede saltar es `make ci` en el workflow de CI.
hooks-install: ## Instalar git hooks (core.hooksPath)
	chmod +x $(addprefix $(HOOKS_SRC)/,$(HOOKS))
	git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'
	@echo "Hooks instalados."

hooks-uninstall: ## Desinstalar git hooks
	-git config --unset core.hooksPath
	@echo "Hooks desinstalados."

hooks-status: ## Ver estado de los git hooks
	@echo "=== Estado de git hooks ==="
	@echo "  core.hooksPath: $$(git config --get core.hooksPath || echo '(no configurado)')"
	@$(foreach hook,$(HOOKS), \
		printf "  %-15s" "$(hook)"; \
		if [ -x "$(HOOKS_SRC)/$(hook)" ]; then echo "✓ ejecutable"; else echo "✗ no ejecutable"; fi;)

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
	@echo "$(MAJOR).$(MINOR).$$(( $(PATCH) + 1 ))" > $(VERSION_FILE)
	@echo "Nueva versión: $$(cat $(VERSION_FILE))"

clean: ## Eliminar artefactos
	$(if $(VENV),,$(error VENV vacía))
	$(if $(DIST),,$(error DIST vacía))
	@rm -rf -- '$(VENV)' '$(DIST)' __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
