# ============================================================
# Lab 05 — Solución: Variables automáticas $(@D) y $(@F)
# Semana 03: Variables automáticas
# ============================================================

.PHONY: all limpiar help

.DEFAULT_GOAL := help

DIST := dist

ARTEFACTOS := \
    $(DIST)/reportes/informe-q1.txt \
    $(DIST)/reportes/informe-q2.txt \
    $(DIST)/datos/estadisticas.csv

## all: genera todos los artefactos en sus subdirectorios
all: $(ARTEFACTOS)

# $(@D) = directorio del target (ej: dist/reportes)
# $(@F) = nombre del archivo del target (ej: informe-q1.txt)
$(DIST)/reportes/%.txt:
	@mkdir -p $(@D)
	@echo "[gen] Directorio: $(@D)"
	@echo "[gen] Archivo:    $(@F)"
	@touch $@

$(DIST)/datos/%.csv:
	@mkdir -p $(@D)
	@echo "[gen] Directorio: $(@D)"
	@echo "[gen] Archivo:    $(@F)"
	@touch $@

## limpiar: elimina el directorio de artefactos completo
limpiar:
	@rm -rf $(DIST)
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [DIST=directorio]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
