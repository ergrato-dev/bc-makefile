# ============================================================
# Lab 03 — Solución: Variables automáticas $^ y $?
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: setup limpiar enlazar help

.DEFAULT_GOAL := help

## enlazar: demuestra que $^ elimina duplicados de la lista de prereqs
enlazar: main.o utils.o math.o main.o utils.o
	@echo "[ld] Lista con duplicados: main.o utils.o math.o main.o utils.o"
	@echo "[ld] \$$^ (deduplicado):     $^"
	@echo "[ld] \$$+ (con duplicados):  $+"

# $? requiere un target real (archivo) para comparar timestamps.
# manual.txt se actualiza con touch $@ para que Make lo reconozca como al día.
manual.txt: seccion-a.txt seccion-b.txt seccion-c.txt
	@echo "[combinar] TODOS los prerrequisitos: $^"
	@echo "[combinar] Solo los MODIFICADOS:    $?"
	@touch $@

# $? en uso real: un registro que solo anota lo que cambió desde la última vez
cambios.log: seccion-a.txt seccion-b.txt seccion-c.txt
	@echo "[log] Cambiaron: $?"
	@echo "$$(date +%T) $?" >> $@

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
