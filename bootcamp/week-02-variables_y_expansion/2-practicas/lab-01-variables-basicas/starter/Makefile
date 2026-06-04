# ============================================================
# Lab 01 — Variables básicas
# Semana 02: Variables y Expansión en Make
# ============================================================
# Instrucciones:
#   1. Completa cada TODO con el operador indicado
#   2. Ejecuta `make help` para ver los targets disponibles
#   3. Verifica con `make info-compilador`, `make info-entorno`, `make info-libs`
# ============================================================

.PHONY: info-compilador info-entorno info-libs help

.DEFAULT_GOAL := help

# ── Compilador ───────────────────────────────────────────────
# TODO: define CC con := (expansión inmediata) con valor "gcc"

# TODO: define CFLAGS con = (expansión recursiva) con valor "-Wall -Wextra -std=c11"

# ── Entorno ───────────────────────────────────────────────────
# TODO: define ENV con ?= con valor "dev"
#       Prueba: make info-entorno ENV=prod  → debe imprimir "prod"

# ── Bibliotecas ───────────────────────────────────────────────
# TODO: define LIBS con := y valor inicial "-lm"

# TODO: agrega "-lpthread" a LIBS con +=
#       Resultado esperado: LIBS = "-lm -lpthread"

## info-compilador: imprime CC y CFLAGS
info-compilador:
	# TODO: @echo "CC:     $(CC)"
	# TODO: @echo "CFLAGS: $(CFLAGS)"

## info-entorno: imprime el entorno actual
info-entorno:
	# TODO: @echo "Entorno: $(ENV)"

## info-libs: imprime las bibliotecas enlazadas
info-libs:
	# TODO: @echo "LIBS: $(LIBS)"
	# Resultado esperado: "LIBS: -lm -lpthread"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|prod]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
