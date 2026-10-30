# ============================================================
# Lab 05 — Solución: Variables automáticas $(@D) y $(@F)
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all limpiar help

.DEFAULT_GOAL := help

DIST := dist

ARTEFACTOS := \
    $(DIST)/reportes/informe-q1.txt \
    $(DIST)/reportes/informe-q2.txt \
    $(DIST)/datos/estadisticas.csv \
    $(DIST)/docs/guia.md \
    $(DIST)/docs/faq.md

all: $(ARTEFACTOS) $(DIST)/indice.txt ## genera todos los artefactos en sus subdirectorios

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

# Copia plantillas/*.md a dist/docs/: entrada y salida en directorios distintos
# $(<D) = plantillas, $(<F) = guia.md; $(@D) = dist/docs, $(@F) = guia.md
$(DIST)/docs/%.md: plantillas/%.md
	@mkdir -p $(@D)
	@echo "[copia] $(<D) / $(<F) → $(@D) / $(@F)"
	@cp $< $@

# Índice: $^ son todos los artefactos; se rehace si alguno es más nuevo
$(DIST)/indice.txt: $(ARTEFACTOS)
	@mkdir -p $(@D)
	@printf '%s\n' $^ > $@
	@echo "[indice] $@ listo."

limpiar: ## elimina el directorio de artefactos completo
	$(if $(DIST),,$(error DIST vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(DIST)'
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [DIST=directorio]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
