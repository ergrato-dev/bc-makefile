.PHONY: lint lint-python lint-shell lint-docs format-python check-tools help
.DEFAULT_GOAL := help

SRC_DIR    := src
SCRIPTS    := scripts
DOCS       := .
MAX_LINE   := 120

FLAKE8     := $(shell command -v flake8 2>/dev/null)
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)

# --------------------------------------------------------------------------
# TODO 1: Implementa check-tools.
#         Para cada herramienta (flake8, shellcheck, mdl/markdownlint),
#         imprime si está disponible o no.
#         Formato: "  flake8       ✓ disponible" o "  flake8       ✗ no instalado"
# --------------------------------------------------------------------------
check-tools: ## Verificar herramientas de calidad instaladas
	@echo "=== Herramientas de calidad ==="
	# TODO: verificar flake8, shellcheck, mdl o markdownlint

# --------------------------------------------------------------------------
# TODO 2: Implementa lint-python.
#         Si flake8 está disponible, úsalo. Si no, usa "python3 -m py_compile"
#         para al menos verificar sintaxis.
#         Nunca debe abortar por herramienta no instalada.
# --------------------------------------------------------------------------
lint-python: ## Análisis estático de Python
	@echo "→ Lint Python..."
	# TODO: if flake8 disponible → usar, else → python3 -m py_compile

# --------------------------------------------------------------------------
# TODO 3: Implementa lint-shell.
#         Si shellcheck está disponible, analiza los .sh en SCRIPTS/.
#         Si no, usa "bash -n" para verificar sintaxis.
# --------------------------------------------------------------------------
lint-shell: ## Análisis estático de scripts bash
	@echo "→ Lint Shell..."
	# TODO: if shellcheck disponible → usar, else → bash -n sobre *.sh

# --------------------------------------------------------------------------
# TODO 4: Implementa lint-docs.
#         Detecta líneas de más de MAX_LINE caracteres en archivos .md.
#         Si hay líneas largas, muestra advertencia pero NO aborta.
# --------------------------------------------------------------------------
lint-docs: ## Verificar documentación Markdown
	@echo "→ Lint Docs..."
	# TODO: buscar líneas > MAX_LINE en *.md con awk o grep

# --------------------------------------------------------------------------
# TODO 5: Implementa lint como target padre que depende de los tres lint.
#         Al terminar imprime: "✓ Lint OK"
# --------------------------------------------------------------------------
lint: ## Ejecutar todos los linters
	# TODO: depender de lint-python lint-shell lint-docs
	@echo "✓ Lint OK"

# --------------------------------------------------------------------------
# TODO 6: Implementa format-python.
#         Si autopep8 está disponible, ejecútalo sobre SRC_DIR.
#         Si no, muestra instrucciones para instalarlo.
# --------------------------------------------------------------------------
format-python: ## Formatear código Python automáticamente
	# TODO: if autopep8 disponible → usar, else → instrucciones

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
