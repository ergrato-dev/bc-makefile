SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: show-scope pass-version help
.DEFAULT_GOAL := help

ENV        ?= development
VERSION    := 1.0.0
SHARED_VAR := valor-compartido
SECRET_VAR ?= no-secret

# Solo lo que se nombra viaja al sub-make. Nunca 'export' a secas.
export SHARED_VAR
# Una variable que ya venía del entorno se exporta sola: unexport lo impide.
unexport SECRET_VAR

show-scope: ## Mostrar qué variables llegan al sub-make
	@echo "=== Padre (MAKELEVEL=$(MAKELEVEL)) invocando sub-make ==="
	@$(MAKE) --no-print-directory -C sub report ENV=$(ENV)

pass-version: ## Pasar VERSION del padre al sub-make de forma explícita
	@echo "=== Padre: VERSION=$(VERSION) ==="
	@$(MAKE) --no-print-directory -C sub report VERSION=$(VERSION)

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
