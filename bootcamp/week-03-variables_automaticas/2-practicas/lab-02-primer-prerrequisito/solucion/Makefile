# ============================================================
# Lab 02 — Solución: Variable automática $<
# Semana 03: Variables automáticas
# ============================================================

.PHONY: compilar-main compilar-utils compilar-todos enlazar help

.DEFAULT_GOAL := help

## compilar-main: simula compilar main.c con sus headers como dependencias
compilar-main: src/main.c include/utils.h include/math.h
	@echo "[cc] Compilando (solo fuente): $<"
	@echo "[cc] Todos los prereqs:        $^"

## compilar-utils: simula compilar utils.c
compilar-utils: src/utils.c include/utils.h
	@echo "[cc] Compilando (solo fuente): $<"
	@echo "[cc] Todos los prereqs:        $^"

## compilar-todos: ejecuta compilar-main y compilar-utils
compilar-todos: compilar-main compilar-utils
	@echo "[resumen] Módulos compilados: $^"

## enlazar: simula enlazar objetos
# $< = main.o (incorrecto para linker: produce "undefined reference" en producción)
# $^ = main.o utils.o math.o (correcto: el linker necesita todos los objetos)
enlazar: main.o utils.o math.o
	@echo "[ld] Primer objeto (incorrecto para linker): $<"
	@echo "[ld] TODOS los objetos (correcto):           $^"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
