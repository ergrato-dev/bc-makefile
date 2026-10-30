# ============================================================
# Lab 06 — Depurar cinco errores en reglas de patrón
# Semana 05: Reglas de patrón
# ============================================================
# Cada sección tiene UN error. Identifícalo, corrígelo,
# verifica con make bug-N, y pasa al siguiente.
# Al terminar: make all-bugs debe completarse sin errores.
# ============================================================

.PHONY: all-bugs setup clean help

.DEFAULT_GOAL := help

# ── Setup: genera los archivos .raw de entrada ────────────────
setup:
	@echo "datos de prueba" > bug-1.raw
	@echo "datos de prueba" > bug-2.raw
	@echo "datos de prueba" > bug-5.raw
	@echo "[setup] archivos .raw creados"

## all-bugs: ejecuta todos los bugs corregidos
all-bugs: setup bug-1 bug-2 bug-3 bug-4 bug-5
	@echo "[ok] todos los bugs corregidos"

# ──────────────────────────────────────────────────────────────
# BUG 1: la receta usa espacios en lugar de TABs
# ERROR: *** missing separator.  Stop.
# ──────────────────────────────────────────────────────────────
%.out-1: %.raw
    @cp $< $@
    @echo "[ok] $@ generado"

bug-1: bug-1.out-1

# ──────────────────────────────────────────────────────────────
# BUG 2: target y prerrequisito invertidos en el patrón
# ERROR: No rule to make target 'bug-2.out-2'
# ──────────────────────────────────────────────────────────────
%.raw: %.out-2
	@cp $< $@
	@echo "[ok] $@ generado"

bug-2: bug-2.out-2

# ──────────────────────────────────────────────────────────────
# BUG 3: $$@ en lugar de $@ — imprime literalmente "$@"
# ERROR: el target se llama "$@" en lugar del nombre real
# ──────────────────────────────────────────────────────────────
%.out-3: %.raw
	@echo "[ok] $$@ generado"

bug-3: bug-3.out-3

# ──────────────────────────────────────────────────────────────
# BUG 4: intenta escribir en out/ sin crearlo primero
# ERROR: out/bug-4.out-4: No such file or directory
# ──────────────────────────────────────────────────────────────
out/%.out-4: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-4: bug-4.raw out/bug-4.out-4

# ──────────────────────────────────────────────────────────────
# BUG 5: prerrequisito fijo sin %, patrón nunca coincide
# ERROR: No rule to make target 'bug-5.out-5'
# ──────────────────────────────────────────────────────────────
%.out-5: bug-5.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-5: bug-5.out-5

# ──────────────────────────────────────────────────────────────

## clean: elimina archivos generados
clean:
	@rm -f *.raw *.out-1 *.out-2 *.out-3 *.out-5
	@rm -rf out
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@echo ""
	@echo "  make setup      crea los .raw de prueba"
	@echo "  make bug-N      prueba el bug N (1-5)"
	@echo "  make all-bugs   ejecuta todos tras las correcciones"
	@echo "  make clean      elimina archivos generados"
