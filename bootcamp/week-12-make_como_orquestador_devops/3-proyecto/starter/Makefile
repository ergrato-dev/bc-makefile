SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: env-check install hooks-install hooks-uninstall hooks-status \
        lint test build report ci version bump-patch clean help
.DEFAULT_GOAL := help

# ---------------------------------------------------------------------------
# Variables — completa las que falten
# ---------------------------------------------------------------------------
UV          := uv
VENV        := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN         := $(UV) run --no-sync
PYTEST      := $(RUN) pytest
FLAKE8      := $(RUN) flake8
APP_NAME    := mi-api
VERSION_FILE := VERSION
# VERSION viene de un archivo del repo: léelo sin shell y valídalo.
VERSION     := $(strip $(or $(file < $(VERSION_FILE)),0.0.0))
VERSION_PARTS := $(subst ., ,$(VERSION))
# TODO 0: valida VERSION. Quitar todos los dígitos debe dejar exactamente
#         ".." y VERSION_PARTS debe tener 3 palabras. Si no, $(error ...).
#         Nunca la pases a $(shell echo $(VERSION) | ...): un PR que ponga
#         `1.0.0';rm -rf ~;'` en VERSION ejecutaría código al hacer `make help`.
MAJOR       := $(word 1,$(VERSION_PARTS))
MINOR       := $(word 2,$(VERSION_PARTS))
PATCH       := $(word 3,$(VERSION_PARTS))
DIST        := dist
SRC         := src
TESTS       := tests
HOOKS_SRC   := scripts/hooks
HOOKS       := pre-commit pre-push
DATE        := $(shell date '+%Y-%m-%d %H:%M:%S')

# .env se parsea como Makefile: valores sin `$`, sin comillas y sin `#`.
-include .env
# TODO 1b: exporta SOLO APP_NAME ENV DB_URL SECRET_KEY (nunca `export` a secas)

# ---------------------------------------------------------------------------
# TODO 1: guard-% — valida variables requeridas con $(if) y $(error),
#         sin pasar el valor por el shell
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
$(VENV)/.installed: pyproject.toml uv.lock
	# TODO: $(UV) sync --locked y touch del sentinel

install: $(VENV)/.installed ## Instalar dependencias Python

# ---------------------------------------------------------------------------
# TODO 4: hooks-install, hooks-uninstall, hooks-status
# ---------------------------------------------------------------------------
hooks-install: ## Instalar git hooks (core.hooksPath)
	# TODO: chmod +x a HOOKS_SRC/* y git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'

hooks-uninstall: ## Desinstalar git hooks
	# TODO: git config --unset core.hooksPath

hooks-status: ## Ver estado de los git hooks
	# TODO: mostrar core.hooksPath y si cada hook es ejecutable

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
	# TODO: escribir $(MAJOR).$(MINOR).$$(( $(PATCH) + 1 )) en VERSION_FILE

# ---------------------------------------------------------------------------
clean: ## Eliminar artefactos
	$(if $(VENV),,$(error VENV vacía))
	$(if $(DIST),,$(error DIST vacía))
	@rm -rf -- '$(VENV)' '$(DIST)' __pycache__ .pytest_cache .coverage
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
