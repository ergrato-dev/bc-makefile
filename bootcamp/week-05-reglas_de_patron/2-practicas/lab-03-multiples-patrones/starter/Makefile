# ============================================================
# Lab 03 — Múltiples reglas de patrón
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Ejecuta: make setup   (crea los archivos .raw de prueba)
#   2. Escribe la regla de patrón para %.processed: %.raw
#   3. Escribe la regla de patrón para %.backup: %.raw
#   4. Verifica con: make process && make backup
#   5. Pasos 7-9 del README: %.processed: %.txt y %.summary
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all setup process backup clean help

.DEFAULT_GOAL := help

# ── Nombres base ──────────────────────────────────────────────
STEMS   := alpha beta gamma
PROC    := $(addsuffix .processed,$(STEMS))
BACKUPS := $(addsuffix .backup,$(STEMS))

# ── Targets principales ───────────────────────────────────────
setup: ## Crea los archivos .raw de prueba
	@for name in $(STEMS); do \
		echo "contenido de $$name" > $$name.raw; \
		echo "[setup] $$name.raw creado"; \
	done

process: $(PROC) ## Convierte todos los .raw a .processed

backup: $(BACKUPS) ## Copia todos los .raw a .backup

# ── Reglas de patrón ──────────────────────────────────────────
# TODO: regla de patrón %.processed: %.raw
#       Receta: @cp $< $@  y  @echo "[raw→processed] $@"

# TODO: regla de patrón %.backup: %.raw
#       Receta: @cp $< $@  y  @echo "[backup] $@"

# TODO (paso 7): regla %.processed: %.txt, DESPUÉS de las anteriores
#       Receta: @tr '[:lower:]' '[:upper:]' < $< > $@  y  @echo "[txt→processed] $@"

# TODO (paso 9): regla %.summary: %.processed
#       Receta: @wc -l < $< > $@  y  @echo "[summary] $@ ($$(cat $@) líneas)"

# ── Utilidades ────────────────────────────────────────────────
clean: ## Elimina todos los archivos generados
	rm -f -- *.raw *.txt *.processed *.backup *.summary

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
