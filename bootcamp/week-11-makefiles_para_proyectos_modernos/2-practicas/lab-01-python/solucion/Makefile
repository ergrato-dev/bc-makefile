SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install test lint format clean help
.DEFAULT_GOAL := help

UV        := uv
VENV      := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN       := $(UV) run --no-sync
PYTEST    := $(RUN) pytest
RUFF      := $(RUN) ruff
SRC_DIR   := src
TESTS_DIR := tests

# El sentinel solo se crea si uv sync terminó bien. Depende de los dos
# archivos que definen el entorno: lo que pides y lo que se instala.
$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias con uv

test: install ## Ejecutar tests con pytest
	$(PYTEST) $(TESTS_DIR) -v

lint: install ## Analizar el código con ruff check
	$(RUFF) check $(SRC_DIR)

format: install ## Reformatear el código con ruff format
	$(RUFF) format $(SRC_DIR) $(TESTS_DIR)

clean: ## Eliminar venv y cachés de Python
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	$(if $(SRC_DIR),,$(error SRC_DIR vacía: rm -rf no se ejecuta))
	$(if $(TESTS_DIR),,$(error TESTS_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' __pycache__ '$(SRC_DIR)/__pycache__' '$(TESTS_DIR)/__pycache__' .pytest_cache .ruff_cache
	@find . -name "*.pyc" -delete
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
