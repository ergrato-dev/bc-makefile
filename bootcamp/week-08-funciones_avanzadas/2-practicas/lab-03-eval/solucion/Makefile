.PHONY: all demo clean help
.DEFAULT_GOAL := help

SUITES  := unit integration e2e performance
REPORTS := reports

define TEST_SUITE_RULE
.PHONY: run-$(1)

run-$(1):
	@mkdir -p $(REPORTS)
	@echo "[$(1)] Ejecutando suite $(1)..."
	@echo "[$(1)] Reporte: $(REPORTS)/$(1).txt"
	@echo "$(1): OK" > $(REPORTS)/$(1).txt
endef

$(foreach suite,$(SUITES),$(eval $(call TEST_SUITE_RULE,$(suite))))

all: $(foreach suite,$(SUITES),run-$(suite)) ## Ejecutar todas las suites

demo: ## Mostrar targets generados dinámicamente
	@echo "Suites:  $(SUITES)"
	@echo "Targets: $(foreach s,$(SUITES),run-$(s))"
	@echo "Reportes: $(foreach s,$(SUITES),$(REPORTS)/$(s).txt)"

clean: ## Limpiar reportes
	@rm -rf $(REPORTS)/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
