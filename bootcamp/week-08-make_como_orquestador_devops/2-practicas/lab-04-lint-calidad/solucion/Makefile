.PHONY: lint lint-python lint-shell lint-docs format-python check-tools help
.DEFAULT_GOAL := help

SRC_DIR    := src
SCRIPTS    := scripts
MAX_LINE   := 120

FLAKE8     := $(shell command -v flake8 2>/dev/null)
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)
AUTOPEP8   := $(shell command -v autopep8 2>/dev/null)

check-tools: ## Verificar herramientas de calidad instaladas
	@echo "=== Herramientas de calidad ==="
	@printf "  %-20s" "flake8"; \
		command -v flake8 >/dev/null 2>&1 && echo "✓ disponible" || echo "✗ no instalado (pip install flake8)"
	@printf "  %-20s" "shellcheck"; \
		command -v shellcheck >/dev/null 2>&1 && echo "✓ disponible" || echo "✗ no instalado (apt install shellcheck)"
	@printf "  %-20s" "autopep8"; \
		command -v autopep8 >/dev/null 2>&1 && echo "✓ disponible" || echo "✗ no instalado (pip install autopep8)"
	@printf "  %-20s" "mdl"; \
		command -v mdl >/dev/null 2>&1 && echo "✓ disponible" || echo "✗ no instalado (gem install mdl)"

lint-python: ## Análisis estático de Python
	@echo "→ Lint Python..."
	@if [ -n "$(FLAKE8)" ]; then \
		$(FLAKE8) $(SRC_DIR); \
	else \
		echo "  (flake8 no instalado — verificando sintaxis con py_compile)"; \
		find $(SRC_DIR) -name '*.py' -exec python3 -m py_compile {} \; && echo "  Sintaxis OK"; \
	fi
	@echo "✓ Lint Python OK"

lint-shell: ## Análisis estático de scripts bash
	@echo "→ Lint Shell..."
	@if [ -n "$(SHELLCHECK)" ]; then \
		find $(SCRIPTS) -name '*.sh' -exec shellcheck {} \;; \
	else \
		echo "  (shellcheck no instalado — verificando sintaxis con bash -n)"; \
		find $(SCRIPTS) -name '*.sh' -exec bash -n {} \; && echo "  Sintaxis OK"; \
	fi
	@echo "✓ Lint Shell OK"

lint-docs: ## Verificar documentación Markdown
	@echo "→ Lint Docs..."
	@LONG_LINES=$$(find . -name '*.md' -not -path './.git/*' \
		-exec awk "length > $(MAX_LINE) {print FILENAME \":\" NR \": \" length \" chars\"}" {} \;); \
	if [ -n "$$LONG_LINES" ]; then \
		echo "  Advertencia: líneas largas (>$(MAX_LINE) chars):"; \
		echo "$$LONG_LINES" | head -5; \
	else \
		echo "  Sin líneas largas."; \
	fi
	@echo "✓ Lint Docs OK"

lint: lint-python lint-shell lint-docs ## Ejecutar todos los linters
	@echo "✓ Lint OK"

format-python: ## Formatear código Python automáticamente
	@if [ -n "$(AUTOPEP8)" ]; then \
		autopep8 --in-place --recursive $(SRC_DIR); \
		echo "✓ Formato aplicado a $(SRC_DIR)/"; \
	else \
		echo "autopep8 no instalado. Instala con: pip install autopep8"; \
	fi

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
