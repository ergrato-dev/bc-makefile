# ============================================================
# Lab 04 — Variable automática $*
# Semana 03: Variables automáticas
# ============================================================
# SECUENCIA RECOMENDADA:
#   1. make setup           → crea archivos .entrada de prueba
#   2. make alfa.resultado  → verifica el stem en un caso individual
#   3. make all             → construye todos los .resultado
#   4. touch beta.entrada   → simula modificación
#   5. make all             → solo beta.resultado se reconstruye
#   6. make limpiar         → elimina .resultado generados
# ============================================================

.PHONY: all setup limpiar help

.DEFAULT_GOAL := help

# ── Archivos de entrada y salida ──────────────────────────────
ENTRADAS := alfa.entrada beta.entrada gamma.entrada
SALIDAS  := $(ENTRADAS:.entrada=.resultado)

## all: procesa todos los archivos .entrada → .resultado
all: $(SALIDAS)

# ── Regla de patrón ───────────────────────────────────────────
# El % en %.resultado coincide con: alfa, beta, gamma
# $* = el stem (la parte que coincidió con %)
%.resultado: %.entrada
	# TODO: imprime "[proceso] Stem:    $*"
	# TODO: imprime "[proceso] Entrada: $<"
	# TODO: imprime "[proceso] Salida:  $@"
	# TODO: copia la entrada a la salida: @cp $< $@

# ── Targets de utilidad ───────────────────────────────────────

## setup: crea archivos .entrada de prueba
setup:
	@echo "datos de alfa"  > alfa.entrada
	@echo "datos de beta"  > beta.entrada
	@echo "datos de gamma" > gamma.entrada
	@echo "[setup] Archivos creados: $(ENTRADAS)"

## limpiar: elimina los archivos generados
limpiar:
	# TODO: elimina todos los archivos .resultado y .entrada
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target | <nombre>.resultado]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
