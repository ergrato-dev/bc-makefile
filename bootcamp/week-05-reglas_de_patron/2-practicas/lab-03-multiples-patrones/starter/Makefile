# ============================================================
# Lab 03 — Múltiples reglas de patrón
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Ejecuta: make setup   (crea los archivos .raw de prueba)
#   2. Escribe la regla de patrón para %.processed: %.raw
#   3. Escribe la regla de patrón para %.backup: %.raw
#   4. Completa los targets 'process' y 'backup'
#   5. Verifica con: make process && make backup
# ============================================================

.PHONY: all setup process backup clean help

.DEFAULT_GOAL := help

# ── Nombres base ──────────────────────────────────────────────
STEMS   := alpha beta gamma
PROC    := $(addsuffix .processed, $(STEMS))
BACKUPS := $(addsuffix .backup, $(STEMS))

# ── Targets principales ───────────────────────────────────────

## setup: crea los archivos .raw de prueba
setup:
	@for name in $(STEMS); do \
		echo "contenido de $$name" > $$name.raw; \
		echo "[setup] $$name.raw creado"; \
	done

## process: convierte todos los .raw a .processed
process: $(PROC)

## backup: convierte todos los .raw a .backup
backup: $(BACKUPS)

# TODO: escribe la regla de patrón %.processed: %.raw
#       Receta: @cp $< $@ y @echo "[ok] $@"

# TODO: escribe la regla de patrón %.backup: %.raw
#       Receta: @cp $< $@ y @echo "[backup] $@"

## clean: elimina todos los archivos generados
clean:
	@rm -f *.raw *.processed *.backup
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
