# ============================================================
# Lab 02 — Expansión recursiva (SOLUCIÓN)
# ============================================================

.PHONY: lazy eager peligro corregido help

.DEFAULT_GOAL := help

# ── Caso 1: con = (lazy) ─────────────────────────────────────
# SALUDO_LAZY se define ANTES que DESTINATARIO_LAZY
# Con = funciona porque se evalúa en el momento de uso
SALUDO_LAZY      = Hola, $(DESTINATARIO_LAZY)!
DESTINATARIO_LAZY = Mundo

# ── Caso 2: con := (eager) ────────────────────────────────────
# SALUDO_EAGER se define ANTES que DESTINATARIO_EAGER
# Con := falla: captura string vacío porque DESTINATARIO_EAGER no existe aún
SALUDO_EAGER       := Hola, $(DESTINATARIO_EAGER)!
DESTINATARIO_EAGER := Mundo

# ── Reto extra: recursión infinita ───────────────────────────
PELIGROSO = $(PELIGROSO)-snapshot

# Versión corregida: usa una variable base separada
BASE_VERSION    := v1.0
VERSION_RELEASE := $(BASE_VERSION)-snapshot

## lazy: = evalúa al usar la variable; DESTINATARIO puede definirse después
lazy:
	@echo "SALUDO_LAZY: $(SALUDO_LAZY)"

## eager: := evalúa al asignar; DESTINATARIO estaba vacío en ese momento
eager:
	@echo "SALUDO_EAGER: $(SALUDO_EAGER)"

## peligro: demuestra el error de recursión infinita con =
peligro:
	@echo "Intentando expandir PELIGROSO..."
	@echo "$(PELIGROSO)"

## corregido: muestra VERSION_RELEASE sin recursión
corregido:
	@echo "VERSION_RELEASE: $(VERSION_RELEASE)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [lazy|eager|peligro|corregido]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
