# ============================================================
# Lab 06 — El patrón help estándar
# Semana 01: Tu primer Makefile
# ============================================================
# Instrucciones:
#   1. Documenta cada target con ' ## descripción' al final de su línea
#   2. Implementa el target 'help' con el patrón grep+awk
#   3. Ejecuta `make help` para verificar
# ============================================================

.PHONY: all build test clean status help

.DEFAULT_GOAL := help

# TODO: añade ' ## <descripción>' al final de la línea de 'all:'
all: build test
	@echo "Pipeline completo."

# TODO: añade ' ## <descripción>' al final de la línea de 'build:'
build:
	@echo "Construyendo..."
	@mkdir -p output
	@touch output/app
	@echo "Build OK."

# TODO: añade ' ## <descripción>' al final de la línea de 'test:'
test: build
	@echo "Ejecutando tests..."
	@echo "Tests OK."

# TODO: añade ' ## <descripción>' al final de la línea de 'clean:'
clean:
	@rm -rf output
	@echo "Limpio."

# TODO: añade ' ## <descripción>' al final de la línea de 'status:'
status:
	@echo "Estado del proyecto:"
	@ls output/ 2>/dev/null && echo "  output/ existe" || echo "  output/ no existe"

# TODO: implementa este target con el patrón grep+awk
help: ## muestra esta ayuda
	@echo "TODO: implementa el patrón help aquí"
	@echo "(pista: grep -hE '^[a-zA-Z_-]+:.*?## ' ... | awk ...)"
