.PHONY: all demo clean help
.DEFAULT_GOAL := help

SUITES  := unit integration e2e performance
REPORTS := reports

# TODO 1: Define la plantilla TEST_SUITE_RULE que genera un target run-$(1):
# - Crea el directorio $(REPORTS)
# - Imprime "[$(1)] Ejecutando suite $(1)..."
# - Imprime "[$(1)] Reporte: $(REPORTS)/$(1).txt"
# - Escribe "$(1): OK" en $(REPORTS)/$(1).txt
# define TEST_SUITE_RULE
# endef

# TODO 2: Usa $(foreach) + $(eval) + $(call) para instanciar TEST_SUITE_RULE
# para cada elemento de $(SUITES)
# Pista: $(foreach suite,$(SUITES),$(eval $(call TEST_SUITE_RULE,$(suite))))

# TODO 3: Elimina los 4 bloques hardcodeados de abajo y reemplaza 'all'
# con: all: $(foreach suite,$(SUITES),run-$(suite))

# CÓDIGO DUPLICADO — elimínalo con $(eval)
.PHONY: run-unit run-integration run-e2e run-performance

run-unit:
	@mkdir -p $(REPORTS)
	@echo "[unit] Ejecutando suite unit..."
	@echo "[unit] Reporte: $(REPORTS)/unit.txt"
	@echo "unit: OK" > $(REPORTS)/unit.txt

run-integration:
	@mkdir -p $(REPORTS)
	@echo "[integration] Ejecutando suite integration..."
	@echo "[integration] Reporte: $(REPORTS)/integration.txt"
	@echo "integration: OK" > $(REPORTS)/integration.txt

run-e2e:
	@mkdir -p $(REPORTS)
	@echo "[e2e] Ejecutando suite e2e..."
	@echo "[e2e] Reporte: $(REPORTS)/e2e.txt"
	@echo "e2e: OK" > $(REPORTS)/e2e.txt

run-performance:
	@mkdir -p $(REPORTS)
	@echo "[performance] Ejecutando suite performance..."
	@echo "[performance] Reporte: $(REPORTS)/performance.txt"
	@echo "performance: OK" > $(REPORTS)/performance.txt

all: run-unit run-integration run-e2e run-performance ## Ejecutar todas las suites

demo: ## Mostrar targets generados
	@echo "Suites:  $(SUITES)"
	@echo "Targets: $(foreach s,$(SUITES),run-$(s))"
	@echo "Reportes: $(foreach s,$(SUITES),$(REPORTS)/$(s).txt)"

clean: ## Limpiar reportes
	@rm -rf $(REPORTS)/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
