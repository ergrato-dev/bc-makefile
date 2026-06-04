.PHONY: all install test lint clean help
.DEFAULT_GOAL := help

PYTHON    := python3
VENV      := .venv
PIP       := $(VENV)/bin/pip
PYTEST    := $(VENV)/bin/pytest
FLAKE8    := $(VENV)/bin/flake8
SRC_DIR   := src
TESTS_DIR := tests

# TODO 1: Define el target '$(VENV)/.installed' con dependencia requirements.txt
#   Receta:
#     $(PYTHON) -m venv $(VENV)
#     $(PIP) install --upgrade pip
#     $(PIP) install -r requirements.txt
#     @touch $@
#   Este archivo vacío es el "sentinel file" — rastrea cuándo se ejecutó pip install.


# TODO 2: Define el target 'install' como alias del sentinel file
#   install: $(VENV)/.installed ## Descripción aquí


# TODO 3: Define el target 'test' que dependa de install y ejecute pytest
#   Pista: $(PYTEST) $(TESTS_DIR) -v


# TODO 4: Define el target 'lint' que dependa de install y ejecute flake8
#   Pista: $(FLAKE8) $(SRC_DIR) --max-line-length=100


# TODO 5: Define el target 'clean' que elimine .venv/ y cachés de Python
#   Pista: rm -rf $(VENV) __pycache__ $(SRC_DIR)/__pycache__ $(TESTS_DIR)/__pycache__ .pytest_cache
#   Imprime "Limpiado." al terminar


help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
