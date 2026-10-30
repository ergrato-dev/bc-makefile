# TODO 0: Preámbulo estricto (Semana 03), antes de cualquier otra línea:
#         SHELL := bash
#         .SHELLFLAGS := -eu -o pipefail -c
#         .DELETE_ON_ERROR:

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

# TODO 1: Define el target '$(VENV)/.installed' con dependencias pyproject.toml y uv.lock
#   Receta:
#     $(UV) sync --locked
#     @touch $@
#   Este archivo vacío es el "sentinel file" — rastrea cuándo se ejecutó uv sync.


# TODO 2: Define el target 'install' como alias del sentinel file
#   install: $(VENV)/.installed ## Descripción aquí


# TODO 3: Define el target 'test' que dependa de install y ejecute pytest
#   Pista: $(PYTEST) $(TESTS_DIR) -v


# TODO 4: Define el target 'lint' que dependa de install y ejecute ruff check
#   Pista: $(RUFF) check $(SRC_DIR)


# TODO 5: Define el target 'format' que dependa de install y reformatee el código
#   Pista: $(RUFF) format $(SRC_DIR) $(TESTS_DIR)


# TODO 6: Define el target 'clean' que elimine .venv/ y cachés de Python
#   Una guarda por variable antes de borrar (Semana 03), p. ej.:
#     $(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
#   Luego: rm -rf -- '$(VENV)' __pycache__ '$(SRC_DIR)/__pycache__' '$(TESTS_DIR)/__pycache__' .pytest_cache .ruff_cache
#   Imprime "Limpiado." al terminar


help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
