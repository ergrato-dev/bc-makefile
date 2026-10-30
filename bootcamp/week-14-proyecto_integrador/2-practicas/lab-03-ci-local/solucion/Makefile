SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: hooks-install hooks-uninstall hooks-status check help
.DEFAULT_GOAL := help

HOOKS_SRC  := hooks
HOOK_FILES := pre-commit pre-push

hooks-install: ## Activar los git hooks de hooks/
	chmod +x $(addprefix $(HOOKS_SRC)/,$(HOOK_FILES))
	git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'
	@echo "✓ Hooks activos desde $(CURDIR)/$(HOOKS_SRC)"

hooks-uninstall: ## Desactivar los git hooks
	-git config --unset core.hooksPath
	@echo "✓ Hooks desinstalados"

hooks-status: ## Ver estado de los hooks
	@echo "Estado de git hooks:"
	@echo "  core.hooksPath: $$(git config --get core.hooksPath || echo '(no configurado)')"
	@$(foreach hook,$(HOOK_FILES), \
		if [ -x "$(HOOKS_SRC)/$(hook)" ]; then echo "  ✓ $(hook) ejecutable"; else echo "  ✗ $(hook) NO ejecutable"; fi;)

check: ## Ejecutar checks de calidad (invocado por los hooks)
	@echo "==> Verificando trailing whitespace ..."
	@if grep -rn ' $$' Makefile hooks/ 2>/dev/null | grep -v '^Binary'; then \
		echo "✗ Trailing whitespace encontrado"; exit 1; \
	fi
	@echo "✓ Checks OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
