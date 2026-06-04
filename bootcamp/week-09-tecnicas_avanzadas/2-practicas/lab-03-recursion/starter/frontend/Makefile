.PHONY: build clean test help
.DEFAULT_GOAL := help

MODULE := frontend

build: ## Compilar módulo frontend
	@echo "[$(MODULE)] build"

clean: ## Limpiar módulo frontend
	@echo "[$(MODULE)] clean"

test: ## Testear módulo frontend
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
