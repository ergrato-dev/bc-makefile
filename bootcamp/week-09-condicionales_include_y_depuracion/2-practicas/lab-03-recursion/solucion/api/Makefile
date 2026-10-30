.PHONY: build clean test help
.DEFAULT_GOAL := help

MODULE := api

build: ## Compilar módulo api
	@echo "[$(MODULE)] build"

clean: ## Limpiar módulo api
	@echo "[$(MODULE)] clean"

test: ## Testear módulo api
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
