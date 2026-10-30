# ============================================================
# Lab 05 — Depurar un Makefile roto
# Semana 01: Tu primer Makefile
# ============================================================
# Este Makefile tiene 4 errores. Encuéntralos y corrígelos.
# Pista: ejecuta `make all` y sigue los mensajes de error.
# ============================================================
#
# ERROR 1: una receta usa espacios en lugar de TAB
# ERROR 2: hay una dependencia circular entre dos targets
# ERROR 3: el target 'test' no está en .PHONY (hay un archivo 'test' aquí)
# ERROR 4: hay un typo en el nombre de una dependencia
# ============================================================

.PHONY: all build clean help
# ERROR 3 está aquí ↑ — falta agregar 'test' al .PHONY

.DEFAULT_GOAL := help

all: build test ## ejecuta build y test

build: ## simula compilación
    @echo "Compilando..."
    @mkdir -p output
    @echo "binario" > output/app
    @echo "Build OK"
# ERROR 1 está en las 4 líneas de arriba (mira con cuidado el whitespace)

# ERROR 2 está en la dependencia de abajo — crea un ciclo con 'all'
test: all ## ejecuta las pruebas
	@echo "Ejecutando tests..."
	@echo "Tests OK"

clean: ## elimina output/
	@rm -rf output
	@echo "Limpio."

# ERROR 4: este target se llama 'verify' pero está referenciado en otro lado como 'validate'
verify: build ## verifica el binario generado
	@test -f output/app && echo "Binario encontrado." || echo "ERROR: binario no encontrado"

validate-output: validate ## valida la salida del build (depende de validate — ERROR 4)
	@echo "Salida validada."

help: ## muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
