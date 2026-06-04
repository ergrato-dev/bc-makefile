# ============================================================
# Lab 06 — El patrón help estándar (SOLUCIÓN)
# ============================================================

.PHONY: all build test clean status help

.DEFAULT_GOAL := help

## all: ejecuta build y test
all: build test
	@echo "Pipeline completo."

## build: construye el proyecto en output/
build:
	@echo "Construyendo..."
	@mkdir -p output
	@touch output/app
	@echo "Build OK."

## test: ejecuta las pruebas
test: build
	@echo "Ejecutando tests..."
	@echo "Tests OK."

## clean: elimina output/
clean:
	@rm -rf output
	@echo "Limpio."

## status: muestra el estado actual del proyecto
status:
	@echo "Estado del proyecto:"
	@ls output/ 2>/dev/null && echo "  output/ existe" || echo "  output/ no existe"

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
