# ============================================================
# Lab 03 — Variables automáticas $^ y $?
# Semana 04: Variables automáticas
# ============================================================
# SECUENCIA RECOMENDADA:
#   1. make enlazar         → observa deduplicación de $^
#   2. make setup           → crea archivos de prueba
#   3. make manual.txt      → "Nothing to be done" (todo está al día)
#   4. touch seccion-b.txt  → marca una sección como modificada
#   5. make manual.txt      → $? muestra solo seccion-b.txt
#   6. make limpiar         → elimina archivos de prueba
# ============================================================

.PHONY: setup limpiar enlazar help

.DEFAULT_GOAL := help

# ── Demo de $^ con deduplicación ──────────────────────────────

## enlazar: demuestra que $^ elimina duplicados de la lista de prereqs
enlazar: main.o utils.o math.o main.o utils.o
	# TODO: imprime "[ld] Lista con duplicados: main.o utils.o math.o main.o utils.o"
	# TODO: imprime "[ld] $^ (deduplicado):     $^"
	# Observa: $^ lista cada objeto una sola vez aunque esté repetido
	# TODO (paso 7): imprime también "[ld] $+ (con duplicados):  $+"

# ── Demo de $? con target real ────────────────────────────────
# $? solo funciona con targets reales (no phony).
# manual.txt es un archivo real; Make compara su timestamp con los prereqs.

manual.txt: seccion-a.txt seccion-b.txt seccion-c.txt
	# TODO: imprime "[combinar] TODOS los prerrequisitos: $^"
	# TODO: imprime "[combinar] Solo los MODIFICADOS:    $?"
	# TODO: actualiza el timestamp del target: @touch $@

# TODO (paso 8): receta de cambios.log usando $? (sin escribir nombres de sección):
#   imprime "[log] Cambiaron: " seguido de $?
#   añade al log (>> $@) una línea con la hora de la shell ($$(date +%T)) y $?
cambios.log: seccion-a.txt seccion-b.txt seccion-c.txt
	@echo "TODO: implementa cambios.log"

# ── Targets de utilidad ───────────────────────────────────────

## setup: crea archivos de prueba con timestamps en el pasado
setup:
	@echo "contenido a" > seccion-a.txt
	@echo "contenido b" > seccion-b.txt
	@echo "contenido c" > seccion-c.txt
	@touch main.o utils.o math.o
	@sleep 1
	@touch manual.txt
	@echo "[setup] Archivos creados (main.o, utils.o y math.o vacíos). manual.txt es más reciente."
	@echo "[setup] Siguiente paso: touch seccion-b.txt && make manual.txt"

## limpiar: elimina archivos de prueba
limpiar:
	@rm -f seccion-a.txt seccion-b.txt seccion-c.txt manual.txt cambios.log main.o utils.o math.o
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
