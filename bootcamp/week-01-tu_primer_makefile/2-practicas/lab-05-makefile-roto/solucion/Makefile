# ============================================================
# Lab 05 — Depurar un Makefile roto (SOLUCIÓN)
# ============================================================
# Correcciones aplicadas:
#   1. Receta de 'build' cambiada de espacios a TABs
#   2. Dependencia circular: 'test' ya no depende de 'all'
#   3. 'test' agregado a .PHONY
#   4. 'validate-output' ahora depende de 'verify' (no 'validate')
# ============================================================

.PHONY: all build test clean verify validate-output help

.DEFAULT_GOAL := help

all: build test ## ejecuta build y test

build: ## simula compilación
	@echo "Compilando..."
	@mkdir -p output
	@echo "binario" > output/app
	@echo "Build OK"

test: ## ejecuta las pruebas
	@echo "Ejecutando tests..."
	@echo "Tests OK"

clean: ## elimina output/
	@rm -rf output
	@echo "Limpio."

verify: build ## verifica el binario generado
	@test -f output/app && echo "Binario encontrado." || echo "ERROR: binario no encontrado"

validate-output: verify ## valida la salida del build
	@echo "Salida validada."

help: ## muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
