# ============================================================
# Lab 03 — Solución: Variables automáticas $^ y $?
# Semana 03: Variables automáticas
# ============================================================

.PHONY: setup limpiar enlazar help

.DEFAULT_GOAL := help

## enlazar: demuestra que $^ elimina duplicados de la lista de prereqs
enlazar: main.o utils.o math.o main.o utils.o
	@echo "[ld] Lista con duplicados: main.o utils.o math.o main.o utils.o"
	@echo "[ld] \$$^ (deduplicado):     $^"

# $? requiere un target real (archivo) para comparar timestamps.
# manual.txt se actualiza con touch $@ para que Make lo reconozca como al día.
manual.txt: seccion-a.txt seccion-b.txt seccion-c.txt
	@echo "[combinar] TODOS los prerrequisitos: $^"
	@echo "[combinar] Solo los MODIFICADOS:    $?"
	@touch $@

## setup: crea archivos de prueba con timestamps en el pasado
setup:
	@echo "contenido a" > seccion-a.txt
	@echo "contenido b" > seccion-b.txt
	@echo "contenido c" > seccion-c.txt
	@sleep 1
	@touch manual.txt
	@echo "[setup] Archivos creados. manual.txt es más reciente."
	@echo "[setup] Siguiente paso: touch seccion-b.txt && make manual.txt"

## limpiar: elimina archivos de prueba
limpiar:
	@rm -f seccion-a.txt seccion-b.txt seccion-c.txt manual.txt
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
