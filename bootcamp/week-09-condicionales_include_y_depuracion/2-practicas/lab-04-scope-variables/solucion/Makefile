SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: show-scope override-demo help
.DEFAULT_GOAL := help

ENV        ?= development
VERSION    := 1.0.0
SHARED_VAR := valor-compartido
SECRET_VAR ?= no-secret

export SHARED_VAR
unexport SECRET_VAR

show-scope: ## Mostrar qué variables llegan al submake
	@echo "=== Padre invocando submake ==="
	@$(MAKE) -C sub report ENV=$(ENV)

override-demo: ## Demostrar paso de VERSION con override
	@echo "=== override-demo: VERSION=$(VERSION) ==="
	@$(MAKE) -C sub report VERSION=$(VERSION)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
