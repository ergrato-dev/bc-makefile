# ============================================================
# Lab 06 — El patrón help estándar (SOLUCIÓN)
# ============================================================

.PHONY: all build test clean status help

.DEFAULT_GOAL := help

all: build test ## ejecuta build y test
	@echo "Pipeline completo."

build: ## construye el proyecto en output/
	@echo "Construyendo..."
	@mkdir -p output
	@touch output/app
	@echo "Build OK."

test: build ## ejecuta las pruebas
	@echo "Ejecutando tests..."
	@echo "Tests OK."

clean: ## elimina output/
	@rm -rf output
	@echo "Limpio."

status: ## muestra el estado actual del proyecto
	@echo "Estado del proyecto:"
	@ls output/ 2>/dev/null && echo "  output/ existe" || echo "  output/ no existe"

help: ## muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
