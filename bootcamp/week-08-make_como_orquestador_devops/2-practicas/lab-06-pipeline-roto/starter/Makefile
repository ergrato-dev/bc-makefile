# Este Makefile tiene 5 errores intencionales. Encuéntralos y corrígelos.
# Pista: usa "make -n", "make --debug=v" y "make -p" para diagnosticar.

# ERROR 1: ci depende de targets en orden incorrecto (build antes de test)
#          y le falta una dependencia crítica
.PHONY: lint test report help
.DEFAULT_GOAL := help

app_name := pipeline-demo
VERSION  := $(shell cat VERSION 2>/dev/null || echo "0.0.0")
DIST     := dist
DATE     = $(shell date '+%Y-%m-%d')

# ERROR 2: Esta variable usa = (expansión lazy) pero se usa en una receta
#          donde su valor ya cambió. Debería ser :=
REPORT_FILE = $(DIST)/report-$(DATE).txt

lint: ## Verificar estilo
	@echo "→ Lint..."
	@echo "✓ Lint OK"

test: lint ## Ejecutar tests
	@echo "→ Tests..."
	@echo "✓ Tests OK"

# ERROR 3: build no está en .PHONY pero tampoco produce un archivo real
build: test ## Construir artefacto
	@mkdir -p $(DIST)
	@echo "Build: $(app_name) $(VERSION)" > $(DIST)/build.txt
	@echo "✓ Build OK"

report: ## Generar reporte
	@mkdir -p $(DIST)
# ERROR 4: La siguiente línea usa espacios en lugar de TAB (no se verá visualmente,
#          pero Make fallará con "missing separator")
        @echo "Reporte: $(app_name) $(VERSION) $(DATE)" > $(REPORT_FILE)
	@echo "✓ Reporte generado: $(REPORT_FILE)"

# ERROR 5: ci depende de build y report pero no en el orden correcto;
#          además le falta el target lint en la cadena
ci: build report ## Ejecutar pipeline completo
	@echo "✓ CI OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
