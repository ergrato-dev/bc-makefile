.PHONY: hooks-install hooks-uninstall hooks-status check help
.DEFAULT_GOAL := help

HOOKS_SRC  := hooks
HOOKS_DST  := .git/hooks
HOOK_FILES := pre-commit pre-push

hooks-install: ## Instalar git hooks del proyecto
	@for hook in $(HOOK_FILES); do \
		cp $(HOOKS_SRC)/$$hook $(HOOKS_DST)/$$hook; \
		chmod +x $(HOOKS_DST)/$$hook; \
	done
	@echo "✓ Hooks instalados en $(HOOKS_DST)/"

hooks-uninstall: ## Desinstalar git hooks
	@for hook in $(HOOK_FILES); do \
		rm -f $(HOOKS_DST)/$$hook; \
	done
	@echo "✓ Hooks desinstalados"

hooks-status: ## Ver estado de los hooks instalados
	@echo "Estado de git hooks:"
	@for hook in $(HOOK_FILES); do \
		if [ -f "$(HOOKS_DST)/$$hook" ]; then \
			echo "  ✓ $$hook instalado"; \
		else \
			echo "  ✗ $$hook NO instalado"; \
		fi; \
	done

check: ## Ejecutar checks de calidad (invocado por los hooks)
	@echo "==> Verificando trailing whitespace ..."
	@if grep -rn ' $$' Makefile hooks/ 2>/dev/null | grep -v '^Binary'; then \
		echo "✗ Trailing whitespace encontrado"; exit 1; \
	fi
	@echo "✓ Checks OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
