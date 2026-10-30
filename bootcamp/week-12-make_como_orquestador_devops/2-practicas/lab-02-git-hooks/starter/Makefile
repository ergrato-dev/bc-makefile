.PHONY: hooks-install hooks-uninstall hooks-status hooks-run-pre-commit help
.DEFAULT_GOAL := help

HOOKS_SRC := scripts/hooks
HOOKS     := pre-commit pre-push

# --------------------------------------------------------------------------
# TODO 1: Implementa hooks-install.
#         - chmod +x a cada hook de $(HOOKS_SRC)
#         - git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'
#         No copies nada a .git/hooks/: no se versiona y se desactualiza.
#         Al terminar imprime: "Hooks instalados."
# --------------------------------------------------------------------------
hooks-install: ## Activar los git hooks de scripts/hooks/
	@echo "Hooks instalados."

# --------------------------------------------------------------------------
# TODO 2: Implementa hooks-uninstall con git config --unset core.hooksPath
#         (prefijo '-': si no estaba configurado, no es un error)
#         Al terminar imprime: "Hooks desinstalados."
# --------------------------------------------------------------------------
hooks-uninstall: ## Desactivar los git hooks
	@echo "Hooks desinstalados."

# --------------------------------------------------------------------------
# TODO 3: Implementa hooks-status.
#         Muestra el valor de core.hooksPath y, para cada hook, si es
#         ejecutable:
#           core.hooksPath: /ruta/scripts/hooks
#           pre-commit     ✓ ejecutable
# --------------------------------------------------------------------------
hooks-status: ## Ver estado de los git hooks
	@echo "=== Estado de git hooks ==="

# --------------------------------------------------------------------------
# TODO 4: Implementa hooks-run-pre-commit: ejecuta $(HOOKS_SRC)/pre-commit
# --------------------------------------------------------------------------
hooks-run-pre-commit: ## Ejecutar el hook pre-commit manualmente

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
