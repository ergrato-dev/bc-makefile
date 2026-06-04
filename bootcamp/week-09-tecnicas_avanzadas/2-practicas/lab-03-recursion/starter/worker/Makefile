.PHONY: build clean test help
.DEFAULT_GOAL := help

MODULE := worker

build: ## Compilar módulo worker
	@echo "[$(MODULE)] build"

clean: ## Limpiar módulo worker
	@echo "[$(MODULE)] clean"

test: ## Testear módulo worker
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
