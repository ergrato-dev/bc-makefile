# ============================================================
# Lab 03 — Múltiples reglas de patrón (SOLUCIÓN)
# Semana 05: Reglas de patrón
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
%.processed: %.raw
	@cp $< $@
	@echo "[raw→processed] $@"

%.backup: %.raw
	@cp $< $@
	@echo "[backup] $@"

# Mismo target, otro prerrequisito: Make elige la que tiene el .txt
%.processed: %.txt
	@tr '[:lower:]' '[:upper:]' < $< > $@
	@echo "[txt→processed] $@"

# Cadena: .raw → .processed → .summary
%.summary: %.processed
	@wc -l < $< > $@
	@echo "[summary] $@ ($$(cat $@) líneas)"

# ── Utilidades ────────────────────────────────────────────────
clean: ## Elimina todos los archivos generados
	rm -f -- *.raw *.txt *.processed *.backup *.summary

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
