# ============================================================
# Lab 06 — El patrón help estándar
# Semana 01: Tu primer Makefile
# ============================================================
# Instrucciones:
#   1. Agrega comentarios '## target: descripción' a cada target
#   2. Implementa el target 'help' con el patrón grep+awk
#   3. Ejecuta `make help` para verificar
# ============================================================

.PHONY: all build test clean status help

.DEFAULT_GOAL := help

# TODO: agrega '## all: ...' justo arriba de este target
all: build test
	@echo "Pipeline completo."

# TODO: agrega '## build: ...' justo arriba de este target
build:
	@echo "Construyendo..."
	@mkdir -p output
	@touch output/app
	@echo "Build OK."

# TODO: agrega '## test: ...' justo arriba de este target
test: build
	@echo "Ejecutando tests..."
	@echo "Tests OK."

# TODO: agrega '## clean: ...' justo arriba de este target
clean:
	@rm -rf output
	@echo "Limpio."

# TODO: agrega '## status: ...' justo arriba de este target
status:
	@echo "Estado del proyecto:"
	@ls output/ 2>/dev/null && echo "  output/ existe" || echo "  output/ no existe"

# TODO: implementa este target con el patrón grep+awk
## help: muestra esta ayuda
help:
	@echo "TODO: implementa el patrón help aquí"
	@echo "(pista: grep -E '^## ' ... | awk ...)"
