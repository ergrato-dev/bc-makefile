SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: build clean test help
.DEFAULT_GOAL := help

FAIL   ?=
MODULE := api

build: ## Compilar módulo api
	@echo "[$(MODULE)] build"

clean: ## Limpiar módulo api
	@echo "[$(MODULE)] clean"

test: ## Testear módulo api (FAIL=api simula un fallo)
	@if [ "$(FAIL)" = "$(MODULE)" ]; then echo "[$(MODULE)] test FALLÓ"; exit 1; fi
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
