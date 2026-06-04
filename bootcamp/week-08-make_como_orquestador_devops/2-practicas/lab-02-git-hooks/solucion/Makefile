.PHONY: hooks-install hooks-uninstall hooks-status hooks-run-pre-commit help
.DEFAULT_GOAL := help

HOOKS_SRC := scripts/hooks
HOOKS_DIR := .git/hooks
HOOKS     := pre-commit pre-push

hooks-install: ## Instalar git hooks desde scripts/hooks/
	@mkdir -p $(HOOKS_DIR)
	@$(foreach hook,$(HOOKS), \
		cp $(HOOKS_SRC)/$(hook) $(HOOKS_DIR)/$(hook) && \
		chmod +x $(HOOKS_DIR)/$(hook) && \
		echo "  Instalado: $(hook)";)
	@echo "Hooks instalados."

hooks-uninstall: ## Desinstalar git hooks
	@$(foreach hook,$(HOOKS), \
		rm -f $(HOOKS_DIR)/$(hook) && \
		echo "  Eliminado: $(hook)";)
	@echo "Hooks desinstalados."

hooks-status: ## Ver estado de los git hooks instalados
	@echo "=== Estado de git hooks ==="
	@$(foreach hook,$(HOOKS), \
		printf "  %-15s" "$(hook)"; \
		if [ -f "$(HOOKS_DIR)/$(hook)" ]; then \
			printf "✓ instalado  "; \
			if [ -x "$(HOOKS_DIR)/$(hook)" ]; then \
				echo "✓ ejecutable"; \
			else \
				echo "✗ no ejecutable"; \
			fi; \
		else \
			echo "✗ no instalado"; \
		fi;)

hooks-run-pre-commit: ## Ejecutar el hook pre-commit manualmente
	@bash $(HOOKS_DIR)/pre-commit

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
