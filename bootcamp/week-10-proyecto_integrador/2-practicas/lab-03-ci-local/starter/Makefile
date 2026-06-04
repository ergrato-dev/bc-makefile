.PHONY: hooks-install hooks-uninstall hooks-status check help
.DEFAULT_GOAL := help

HOOKS_SRC := hooks
HOOKS_DST := .git/hooks
HOOK_FILES := pre-commit pre-push

# TODO: implementar hooks-install
# Debe:
#   1. Para cada hook en HOOK_FILES: copiar $(HOOKS_SRC)/$$hook → $(HOOKS_DST)/$$hook
#   2. Hacer chmod +x en cada hook instalado
#   3. Imprimir: ✓ Hooks instalados en $(HOOKS_DST)/
hooks-install: ## Instalar git hooks del proyecto

# TODO: implementar hooks-uninstall
# Debe eliminar $(HOOKS_DST)/pre-commit y $(HOOKS_DST)/pre-push
# Imprimir: ✓ Hooks desinstalados
hooks-uninstall: ## Desinstalar git hooks

# TODO: implementar hooks-status
# Para cada hook en HOOK_FILES:
#   - Si $(HOOKS_DST)/$$hook existe: imprimir "  ✓ $$hook instalado"
#   - Si no existe: imprimir "  ✗ $$hook NO instalado"
hooks-status: ## Ver estado de los hooks instalados

# TODO: implementar check
# Debe ejecutar al menos:
#   - Verificar que no hay archivos con trailing whitespace (grep -rn ' $' src/ o similar)
#   - Imprimir: ✓ Checks OK
check: ## Ejecutar checks de calidad (invocado por los hooks)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
