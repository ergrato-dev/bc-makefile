.PHONY: hooks-install hooks-uninstall hooks-status check help
.DEFAULT_GOAL := help

HOOKS_SRC  := hooks
HOOK_FILES := pre-commit pre-push

# TODO: modo estricto (SHELL, .SHELLFLAGS con pipefail, .DELETE_ON_ERROR)

# TODO: implementar hooks-install
# Debe:
#   1. chmod +x a cada hook de $(HOOKS_SRC)
#   2. git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'
#   3. Imprimir: ✓ Hooks activos desde <ruta>
hooks-install: ## Activar los git hooks de hooks/

# TODO: implementar hooks-uninstall con git config --unset core.hooksPath
# Imprimir: ✓ Hooks desinstalados
hooks-uninstall: ## Desactivar los git hooks

# TODO: implementar hooks-status
# Mostrar core.hooksPath y, para cada hook, si es ejecutable
hooks-status: ## Ver estado de los hooks

# TODO: implementar check
# Debe ejecutar al menos:
#   - Verificar que no hay archivos con trailing whitespace (grep -rn ' $' src/ o similar)
#   - Imprimir: ✓ Checks OK
check: ## Ejecutar checks de calidad (invocado por los hooks)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
