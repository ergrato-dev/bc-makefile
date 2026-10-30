# ============================================================
# Módulo api — lo usa el Makefile raíz. No necesitas tocarlo.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: build clean test help
.DEFAULT_GOAL := help

MODULE   := api
DIST_DIR := dist
FAIL     ?=

# STAGE no se define aquí: llega del raíz (si lo exporta) o de la línea de comandos.
build: ## Compilar módulo api
	@mkdir -p $(DIST_DIR)
	@echo "$(MODULE) STAGE=$(STAGE)" > $(DIST_DIR)/$(MODULE).txt
	@echo "[$(MODULE)] build (STAGE=$(STAGE))"

clean: ## Limpiar módulo api
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(DIST_DIR)'
	@echo "[$(MODULE)] clean"

test: ## Testear módulo api (FAIL=api simula un fallo)
	@if [ "$(FAIL)" = "$(MODULE)" ]; then echo "[$(MODULE)] test FALLÓ"; exit 1; fi
	@echo "[$(MODULE)] test"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
