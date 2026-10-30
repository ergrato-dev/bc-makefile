# ============================================================
# Lab 04 — Recursión que no se traga los fallos
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean test status help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test

# --------------------------------------------------------------------------
# ANTIPATRÓN (no lo uses): sin -e, el código de salida del bucle es el del
# último módulo; si api falla pero frontend pasa, `make test` sale con 0.
# Con -e se para en el primero, pero -j y -k siguen sin poder hacer nada.
#
#   test:
#   	for mod in $(MODULES); do $(MAKE) -C $$mod test; done
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 4 (paso 7): define STAGE ?= dev y expórtala por su nombre para que
#         los módulos la vean. Nunca 'export' a secas: exportaría todo.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 1: Define MODULE_TARGETS con un nombre por módulo y meta:
#         api/build api/clean api/test worker/build ...
#         Tip: $(foreach g,$(GOALS),$(addsuffix /$(g),$(MODULES)))
#         Decláralos .PHONY: no son archivos.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Una sola regla para todos los MODULE_TARGETS que ejecute
#         $(MAKE) --no-print-directory -C <directorio> <meta>
#         Tip: en "api/test", $(@D) es "api" y $(@F) es "test"
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 3: all, clean y test sin receta: solo prerrequisitos
#         Ejemplo: all: $(addsuffix /build,$(MODULES))
# --------------------------------------------------------------------------
all: ## Construir todos los módulos

clean: ## Limpiar artefactos de todos los módulos

test: ## Ejecutar tests en todos los módulos

# --------------------------------------------------------------------------
# TODO 5: 'status' lista cada módulo con ✓ si tiene Makefile y ✗ si no
#         (sin construir nada). Tip: $(wildcard $(m)/Makefile)
# --------------------------------------------------------------------------
status: ## Mostrar estado de todos los módulos
	@echo "TODO: implementa status"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
