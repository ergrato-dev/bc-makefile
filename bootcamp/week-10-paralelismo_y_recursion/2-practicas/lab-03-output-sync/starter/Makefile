# ============================================================
# Lab 03 — Salida legible con -O 
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# --- Paralelismo ---------------------------------------------
# TODO 1: que 'make -j4 test' salga agrupado sin escribir -O.
#         Define OUTPUT_SYNC ?= target y añade --output-sync=$(OUTPUT_SYNC)
#         a MAKEFLAGS con +=. El orden importa: primero la variable.

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
# TODO 2: añade a la línea "preparando" si stdout es una terminal o no:
#         "(stdout: terminal)" o "(stdout: archivo)".
#         Tip: if [ -t 1 ]; then out=terminal; else out=archivo; fi; echo ... $$out
#         (no uses $$(...): dentro de una sustitución stdout siempre es una tubería)
$(TEST_SUITES): test-%:
	@echo "[$*] preparando"
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
