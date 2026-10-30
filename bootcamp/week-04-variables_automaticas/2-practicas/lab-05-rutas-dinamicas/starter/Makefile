# ============================================================
# Lab 05 — Variables automáticas $(@D) y $(@F)
# Semana 04: Variables automáticas
# ============================================================
# Objetivo: construir artefactos en subdirectorios usando $(@D) y $(@F)
# sin hardcodear rutas en las recetas.
# ============================================================

.PHONY: all limpiar help

.DEFAULT_GOAL := help

# ── Directorio base de salida ─────────────────────────────────
# Cambia DIST para mover toda la estructura sin tocar las recetas
DIST := dist

# ── Artefactos a construir ────────────────────────────────────
ARTEFACTOS := \
    $(DIST)/reportes/informe-q1.txt \
    $(DIST)/reportes/informe-q2.txt \
    $(DIST)/datos/estadisticas.csv

## all: genera todos los artefactos en sus subdirectorios
all: $(ARTEFACTOS)

# ── Reglas de patrón ──────────────────────────────────────────

# Genera archivos .txt en dist/reportes/
$(DIST)/reportes/%.txt:
	# TODO: crea el directorio con @mkdir -p $(@D)
	# TODO: imprime "[gen] Directorio: $(@D)"
	# TODO: imprime "[gen] Archivo:    $(@F)"
	# TODO: crea el archivo: @touch $@

# Genera archivos .csv en dist/datos/
$(DIST)/datos/%.csv:
	# TODO: mismo patrón que la regla anterior
	# TODO: crea directorio, imprime $(@D) y $(@F), toca el archivo

## limpiar: elimina el directorio de artefactos completo
limpiar:
	# TODO: @rm -rf $(DIST)
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [DIST=directorio]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
