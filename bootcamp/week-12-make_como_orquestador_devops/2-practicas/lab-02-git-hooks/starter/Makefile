.PHONY: hooks-install hooks-uninstall hooks-status hooks-run-pre-commit help
.DEFAULT_GOAL := help

HOOKS_SRC := scripts/hooks
HOOKS_DIR := .git/hooks
HOOKS     := pre-commit pre-push

# --------------------------------------------------------------------------
# TODO 1: Implementa hooks-install.
#         Debe copiar cada hook de HOOKS_SRC a HOOKS_DIR y hacerlo ejecutable.
#         Si .git/hooks no existe, debe crearlo.
#         Al terminar imprime: "Hooks instalados."
# --------------------------------------------------------------------------
hooks-install: ## Instalar git hooks desde scripts/hooks/
	# TODO: crear HOOKS_DIR si no existe
	# TODO: iterar $(HOOKS) y copiar cada uno + chmod +x
	@echo "Hooks instalados."

# --------------------------------------------------------------------------
# TODO 2: Implementa hooks-uninstall.
#         Debe eliminar los hooks instalados de HOOKS_DIR.
#         Al terminar imprime: "Hooks desinstalados."
# --------------------------------------------------------------------------
hooks-uninstall: ## Desinstalar git hooks
	# TODO: iterar $(HOOKS) y eliminar cada uno de HOOKS_DIR
	@echo "Hooks desinstalados."

# --------------------------------------------------------------------------
# TODO 3: Implementa hooks-status.
#         Para cada hook en HOOKS, muestra si existe y si es ejecutable.
#         Formato sugerido:
#           pre-commit   ✓ instalado  ✓ ejecutable
#           pre-push     ✗ no instalado
# --------------------------------------------------------------------------
hooks-status: ## Ver estado de los git hooks instalados
	@echo "=== Estado de git hooks ==="
	# TODO: iterar $(HOOKS) y verificar existencia y permisos

# --------------------------------------------------------------------------
# TODO 4: Implementa hooks-run-pre-commit.
#         Debe ejecutar el script pre-commit directamente (sin hacer commit).
# --------------------------------------------------------------------------
hooks-run-pre-commit: ## Ejecutar el hook pre-commit manualmente
	# TODO: ejecutar $(HOOKS_DIR)/pre-commit

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
