SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: build clean test help
.DEFAULT_GOAL := help

FAIL   ?=
MODULE := frontend

build: ## Compilar módulo frontend
	@echo "[$(MODULE)] build"

clean: ## Limpiar módulo frontend
	@echo "[$(MODULE)] clean"

test: ## Testear módulo frontend (FAIL=frontend simula un fallo)
	@if [ "$(FAIL)" = "$(MODULE)" ]; then echo "[$(MODULE)] test FALLÓ"; exit 1; fi
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
