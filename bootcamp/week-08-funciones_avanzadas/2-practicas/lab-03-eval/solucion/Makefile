SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all demo show-rule clean help
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

# $(value) muestra la plantilla sin expandir; $(call) muestra el texto exacto que recibe $(eval)
show-rule: ## Mostrar la plantilla cruda y la regla generada para unit
	$(info --- plantilla cruda ---)
	$(info $(value TEST_SUITE_RULE))
	$(info --- regla generada para unit ---)
	$(info $(call TEST_SUITE_RULE,unit))
	@:

clean: ## Limpiar reportes
	$(if $(REPORTS),,$(error REPORTS vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(REPORTS)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
