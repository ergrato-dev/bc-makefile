# Este Makefile tiene 5 errores intencionales. Encuéntralos y corrígelos.
# Pista: usa "make -n", "make --debug=v" y "make -p" para diagnosticar.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: lint test report ci clean help

clean: ## Eliminar artefactos
	$(if $(DIST),,$(error DIST vacía))
	@rm -rf -- '$(DIST)'
	@echo "Limpiado."

REPORT_FILE := $(DIST)/report-$(DATE).txt

APP_NAME := pipeline-demo
VERSION  := $(shell cat VERSION 2>/dev/null || echo "0.0.0")
DIST     := build
DATE     := $(shell date '+%Y-%m-%d')

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

ci: lint test build ## Ejecutar pipeline completo
	@echo "✓ CI OK"

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
