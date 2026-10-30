.PHONY: all install test lint clean help
.DEFAULT_GOAL := help

PYTHON    := python3
VENV      := .venv
PIP       := $(VENV)/bin/pip
PYTEST    := $(VENV)/bin/pytest
FLAKE8    := $(VENV)/bin/flake8
SRC_DIR   := src
TESTS_DIR := tests

$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $@

install: $(VENV)/.installed ## Crear venv e instalar dependencias

test: install ## Ejecutar tests con pytest
	$(PYTEST) $(TESTS_DIR) -v

lint: install ## Verificar estilo con flake8
	$(FLAKE8) $(SRC_DIR) --max-line-length=100

clean: ## Eliminar venv y cachés de Python
	@rm -rf $(VENV) __pycache__ $(SRC_DIR)/__pycache__ $(TESTS_DIR)/__pycache__ .pytest_cache
	@find . -name "*.pyc" -delete
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
