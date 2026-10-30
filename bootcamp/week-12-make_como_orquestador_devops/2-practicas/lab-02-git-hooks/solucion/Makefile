SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: hooks-install hooks-uninstall hooks-status hooks-run-pre-commit help
.DEFAULT_GOAL := help

HOOKS_SRC := scripts/hooks
HOOKS     := pre-commit pre-push

# core.hooksPath hace que git lea los hooks directamente de scripts/hooks/,
# que está versionado: nada que copiar, nada que se desactualice.
hooks-install: ## Activar los git hooks de scripts/hooks/
	chmod +x $(addprefix $(HOOKS_SRC)/,$(HOOKS))
	git config core.hooksPath '$(CURDIR)/$(HOOKS_SRC)'
	@echo "Hooks instalados."

hooks-uninstall: ## Desactivar los git hooks
	-git config --unset core.hooksPath
	@echo "Hooks desinstalados."

hooks-status: ## Ver estado de los git hooks
	@echo "=== Estado de git hooks ==="
	@echo "  core.hooksPath: $$(git config --get core.hooksPath || echo '(no configurado)')"
	@$(foreach hook,$(HOOKS), \
		printf "  %-15s" "$(hook)"; \
		if [ -x "$(HOOKS_SRC)/$(hook)" ]; then echo "✓ ejecutable"; else echo "✗ no ejecutable"; fi;)

hooks-run-pre-commit: ## Ejecutar el hook pre-commit manualmente
	./$(HOOKS_SRC)/pre-commit

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
