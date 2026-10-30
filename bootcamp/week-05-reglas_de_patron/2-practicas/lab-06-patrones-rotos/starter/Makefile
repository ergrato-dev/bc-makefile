# ============================================================
# Lab 06 — Depurar seis errores en reglas de patrón
# Semana 05: Reglas de patrón
# ============================================================
# Cada sección tiene UN error. Arréglalos en orden: el bug 1
# impide que Make lea el archivo entero.
# Al terminar: make all-bugs debe completarse sin errores.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all-bugs setup clean help

.DEFAULT_GOAL := help

INPUTS := bug-1.raw bug-2.raw bug-3.raw bug-4.raw bug-5.sh bug-6.raw

setup: $(INPUTS) ## Crea los archivos de entrada

# Los archivos de entrada son targets: Make sabe crearlos cuando los necesita
$(filter %.raw,$(INPUTS)): bug-%.raw:
	@echo "datos de prueba $*" > $@

bug-5.sh:
	@printf '#!/bin/sh\necho "script de despliegue"\n' > $@

all-bugs: setup bug-1 bug-2 bug-3 bug-4 bug-5 bug-6 ## Ejecuta los seis casos
	@echo "[ok] todos los bugs corregidos"

# ──────────────────────────────────────────────────────────────
# BUG 1
# ──────────────────────────────────────────────────────────────
%.out-1: %.raw
    @cp $< $@
    @echo "[ok] $@ generado"

bug-1: bug-1.out-1

# ──────────────────────────────────────────────────────────────
# BUG 2
# ──────────────────────────────────────────────────────────────
%.raw: %.out-2
	@cp $< $@
	@echo "[ok] $@ generado"

bug-2: bug-2.out-2

# ──────────────────────────────────────────────────────────────
# BUG 3
# ──────────────────────────────────────────────────────────────
%.out-3: %.raw
	@cp $< $@
	@echo "[ok] $$@ generado"

bug-3: bug-3.out-3

# ──────────────────────────────────────────────────────────────
# BUG 4
# ──────────────────────────────────────────────────────────────
out/%.out-4: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-4: out/bug-4.out-4

# ──────────────────────────────────────────────────────────────
# BUG 5
# ──────────────────────────────────────────────────────────────
%.out-5: %.sh
	@bash $< > $@
	@echo "[ok] $@ generado"

bug-5: bug-5.out-5

# ──────────────────────────────────────────────────────────────
# BUG 6
# ──────────────────────────────────────────────────────────────
OUTS_6 := bug-6.out6

$(OUTS_6): %.out-6: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-6: $(OUTS_6)

# ──────────────────────────────────────────────────────────────

clean: ## Elimina archivos generados
	rm -f -- bug-* *.out-*
	rm -rf -- out

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
