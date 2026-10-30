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
    $(DIST)/datos/estadisticas.csv \
    $(DIST)/docs/guia.md \
    $(DIST)/docs/faq.md

## all: genera todos los artefactos en sus subdirectorios
all: $(ARTEFACTOS) $(DIST)/indice.txt

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

# TODO (limpiar): guarda + borrado seguro de la semana 03. Receta:
#   $(if $(DIST),,$(error DIST vacía: rm -rf no se ejecuta))
#   @rm -rf -- '$(DIST)'
# TODO (paso 7): copia plantillas/%.md a dist/docs/%.md
#   - crea el directorio de salida con mkdir -p y $(@D)
#   - imprime "[copia] $(<D) / $(<F) → $(@D) / $(@F)"
#   - copia con cp $< $@
$(DIST)/docs/%.md: plantillas/%.md
	@echo "TODO: implementa la copia de $<"

# TODO (paso 8): índice con una línea por artefacto
#   - crea el directorio con mkdir -p y $(@D)
#   - escribe la lista: printf '%s\n' $^ > $@
#   - imprime "[indice] $@ listo."
$(DIST)/indice.txt: $(ARTEFACTOS)
	@echo "TODO: implementa el índice"

## limpiar: elimina el directorio de artefactos completo
limpiar:
	# TODO: borrado con guarda (semana 03); las dos líneas van con TAB, sin #
	@echo "[limpiar] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [DIST=directorio]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
