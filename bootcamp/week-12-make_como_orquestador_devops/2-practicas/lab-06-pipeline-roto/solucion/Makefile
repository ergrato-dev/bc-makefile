# Solución: los 5 errores corregidos
#
# Error 1: .PHONY no incluía build ni ci → agregados
# Error 2: REPORT_FILE usaba = (lazy) → cambiado a :=
# Error 3: build no estaba en .PHONY → agregado
# Error 4: receta en report usaba espacios → corregido a TAB
# Error 5: ci no encadenaba lint→test→build→report en orden → corregido

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: lint test build report ci help
.DEFAULT_GOAL := help

APP_NAME    := pipeline-demo
VERSION     := $(shell cat VERSION 2>/dev/null || echo "0.0.0")
DIST        := dist
DATE        := $(shell date '+%Y-%m-%d')
REPORT_FILE := $(DIST)/report-$(DATE).txt

lint: ## Verificar estilo
	@echo "→ Lint..."
	@echo "✓ Lint OK"

test: lint ## Ejecutar tests
	@echo "→ Tests..."
	@echo "✓ Tests OK"

build: test ## Construir artefacto
	@mkdir -p $(DIST)
	@echo "Build: $(APP_NAME) $(VERSION)" > $(DIST)/build.txt
	@echo "✓ Build OK"

report: ## Generar reporte
	@mkdir -p $(DIST)
	@echo "Reporte: $(APP_NAME) $(VERSION) $(DATE)" > $(REPORT_FILE)
	@echo "✓ Reporte generado: $(REPORT_FILE)"

ci: lint test build report ## Ejecutar pipeline completo
	@echo "✓ CI OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
