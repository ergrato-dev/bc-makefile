# ============================================================
# Lab 04 — Recursión que no se traga los fallos (SOLUCIÓN)
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean test status help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test

# Las variables de la línea de comandos (make all STAGE=prod) llegan
# solas a los sub-makes, dentro de MAKEFLAGS. Las definidas aquí solo
# llegan si se exportan, y siempre por nombre: nunca 'export' a secas.
STAGE ?= dev
export STAGE

# Un target phony por módulo y meta: api/build, api/clean, worker/test...
# Cada uno es un nodo del grafo: si falla, Make se detiene y -j los paraleliza.
MODULE_TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(MODULES)))
.PHONY: $(MODULE_TARGETS)

# En api/test, $(@D) es api y $(@F) es test.
$(MODULE_TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F)

all: $(addsuffix /build,$(MODULES)) ## Construir todos los módulos

clean: $(addsuffix /clean,$(MODULES)) ## Limpiar artefactos de todos los módulos

test: $(addsuffix /test,$(MODULES)) ## Ejecutar tests en todos los módulos

status: ## Mostrar estado de todos los módulos
	@echo "Módulos registrados: $(MODULES)"
	@$(foreach m,$(MODULES),echo "  $(if $(wildcard $(m)/Makefile),✓,✗) $(m)";)

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
