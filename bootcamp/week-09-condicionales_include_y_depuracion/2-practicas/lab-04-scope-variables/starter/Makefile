SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: show-scope pass-version help
.DEFAULT_GOAL := help

ENV        ?= development
VERSION    := 1.0.0
SHARED_VAR := valor-compartido
SECRET_VAR ?= no-secret

# --------------------------------------------------------------------------
# TODO 1 (paso 3): exporta SHARED_VAR (solo esa: nunca 'export' a secas).
# TODO 3 (paso 5): impide que SECRET_VAR llegue al sub-make aunque venga
#                  del entorno (unexport).
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2 (paso 4): pasa ENV de forma explícita al sub-make (ENV=$(ENV)).
# --------------------------------------------------------------------------
show-scope: ## Mostrar qué variables llegan al sub-make
	@echo "=== Padre (MAKELEVEL=$(MAKELEVEL)) invocando sub-make ==="
	@$(MAKE) --no-print-directory -C sub report

# --------------------------------------------------------------------------
# TODO 4 (paso 6): invoca 'report' en sub/ pasando VERSION=$(VERSION).
# --------------------------------------------------------------------------
pass-version: ## Pasar VERSION del padre al sub-make de forma explícita
	@echo "=== Padre: VERSION=$(VERSION) ==="

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
