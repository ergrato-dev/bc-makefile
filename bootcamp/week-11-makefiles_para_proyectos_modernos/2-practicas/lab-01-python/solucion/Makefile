SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install test lint clean help
.DEFAULT_GOAL := help

UV        := uv
VENV      := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN       := $(UV) run --no-sync
PYTEST    := $(RUN) pytest
FLAKE8    := $(RUN) flake8
SRC_DIR   := src
TESTS_DIR := tests

$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias con uv

test: install ## Ejecutar tests con pytest
	$(PYTEST) $(TESTS_DIR) -v

lint: install ## Verificar estilo con flake8
	$(FLAKE8) $(SRC_DIR) --max-line-length=100

clean: ## Eliminar venv y cachés de Python
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	$(if $(SRC_DIR),,$(error SRC_DIR vacía: rm -rf no se ejecuta))
	$(if $(TESTS_DIR),,$(error TESTS_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' __pycache__ '$(SRC_DIR)/__pycache__' '$(TESTS_DIR)/__pycache__' .pytest_cache
	@find . -name "*.pyc" -delete
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
