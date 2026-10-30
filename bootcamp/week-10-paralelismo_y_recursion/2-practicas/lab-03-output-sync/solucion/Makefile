# ============================================================
# Lab 03 — Salida legible con -O (SOLUCIÓN)
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# --- Paralelismo ---------------------------------------------
# Con -j, cada target imprime su salida en bloque al terminar.
# OUTPUT_SYNC va antes que MAKEFLAGS: Make 4.4 lee MAKEFLAGS en
# cuanto cambia. make -j4 test OUTPUT_SYNC=none la muestra cruda.
OUTPUT_SYNC ?= target
MAKEFLAGS   += --output-sync=$(OUTPUT_SYNC)

# --- Configuración -------------------------------------------
SUITES      := api db ui
E2E         := login pago
FAIL        ?=
TEST_SUITES := $(addprefix test-,$(SUITES))
E2E_SUITES  := $(addprefix e2e-,$(E2E))

.PHONY: test test-e2e $(TEST_SUITES) $(E2E_SUITES) help
.DEFAULT_GOAL := help

# --- Tests ---------------------------------------------------
test: $(TEST_SUITES) test-e2e ## Ejecuta todas las suites

# Varias líneas de receta con pausas: sin -O, se entrelazan.
# [ -t 1 ] dice si stdout es una terminal: con -O no lo es, porque
# Make guarda la salida en un archivo temporal hasta el final.
$(TEST_SUITES): test-%:
	@if [ -t 1 ]; then out=terminal; else out=archivo; fi; echo "[$*] preparando (stdout: $$out)"
	@sleep 0.2
	@for c in 1 2 3; do echo "[$*] caso $$c"; sleep 0.1; done
	@if [ '$(FAIL)' = '$*' ]; then echo "[$*] FALLÓ en el caso 3"; exit 1; fi
	@echo "[$*] OK"

# Las e2e van en un sub-make: sirven para comparar -Otarget con -Orecurse.
test-e2e: ## Ejecuta las suites e2e en un sub-make
	@echo "[e2e] lanzando sub-make"
	@$(MAKE) --no-print-directory $(E2E_SUITES)

# pago tarda más que el resto a propósito.
$(E2E_SUITES): e2e-%:
	@echo "  [e2e/$*] inicio"
	@sleep $(if $(filter pago,$*),1,0.1)
	@echo "  [e2e/$*] fin"

# --- Utilidades ----------------------------------------------
help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
