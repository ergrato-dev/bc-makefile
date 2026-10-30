# Solución: los 5 errores corregidos
#
# Error 1: ci no incluía report → el pipeline terminaba sin reporte
# Error 2: REPORT_FILE se definía con := antes que DIST y DATE → valía
#          "/report-.txt" y la escritura fallaba con "Permission denied"
# Error 3: build no estaba en .PHONY y DIST es build/ → en la segunda
#          ejecución Make veía el directorio "al día" y se saltaba el build
# Error 4: la receta de report usaba espacios en vez de TAB → missing separator
# Error 5: clean era el primer target y no había .DEFAULT_GOAL → "make" a
#          secas borraba los artefactos en lugar de mostrar la ayuda

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: lint test build report ci clean help
.DEFAULT_GOAL := help

APP_NAME    := pipeline-demo
VERSION     := $(shell cat VERSION 2>/dev/null || echo "0.0.0")
DIST        := build
DATE        := $(shell date '+%Y-%m-%d')
REPORT_FILE := $(DIST)/report-$(DATE).txt

lint: ## Verificar estilo
	@echo "→ Lint..."
	@echo "✓ Lint OK"

test: ## Ejecutar tests
	@echo "→ Tests..."
	@echo "✓ Tests OK"

build: ## Construir artefacto
	@mkdir -p $(DIST)
	@echo "Build $(APP_NAME) $(VERSION)" > $(DIST)/app.txt
	@echo "✓ Build OK"

report: ## Generar reporte
	@mkdir -p $(DIST)
	@echo "Reporte $(APP_NAME) $(VERSION) $(DATE)" > $(REPORT_FILE)
	@echo "✓ Reporte generado: $(REPORT_FILE)"

ci: lint test build report ## Ejecutar pipeline completo
	@echo "✓ CI OK"

clean: ## Eliminar artefactos
	$(if $(DIST),,$(error DIST vacía))
	@rm -rf -- '$(DIST)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
