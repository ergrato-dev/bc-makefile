# ============================================================
# Lab 05 — $(MAKE) y el jobserver (SOLUCIÓN)
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: literal recursive twice lib-1 lib-2 forced forced-1 forced-2 hidden flags concurrency clean help
.DEFAULT_GOAL := help

# Traza compartida por todos los sub-makes (se exporta por nombre).
TRACE := $(CURDIR)/trace.log
export TRACE

# Un sub-make escondido en una variable: Make no ve "$(MAKE)" en la línea.
SUBMAKE = $(MAKE) --no-print-directory

# --- Sub-makes -----------------------------------------------
# MAL: 'make' literal. Make no sabe que es un sub-make: en 4.3 no le
# pasa el jobserver (-j1) y con -n no lo ejecuta.
literal: ## Sub-make con make literal (antipatrón)
	make --no-print-directory -C lib

# BIEN: $(MAKE) marca la línea como recursiva: mismo binario, mismos
# flags, jobserver compartido, y se ejecuta también con -n.
recursive: ## Sub-make con $(MAKE)
	$(MAKE) --no-print-directory -C lib

# Dos sub-makes en paralelo comparten el mismo jobserver: con -j4,
# entre los dos nunca pasan de 4 tareas a la vez.
twice: lib-1 lib-2 ## Dos sub-makes en paralelo con un solo jobserver

lib-1 lib-2:
	@$(MAKE) --no-print-directory -C lib

# MAL: -j dentro de la receta. Cada hijo crea su propio jobserver y
# con make -j4 forced corren hasta 8 tareas a la vez.
forced: forced-1 forced-2 ## Dos sub-makes con -j4 forzado (antipatrón)

forced-1 forced-2:
	@$(MAKE) --no-print-directory -j4 -C lib

# '+' marca la línea como recursiva aunque $(MAKE) esté escondido.
hidden: ## Sub-make dentro de una variable, marcado con +
	+$(SUBMAKE) -C lib

flags: ## Muestra lo que hereda el sub-make
	@$(MAKE) --no-print-directory -C lib flags

# --- Medición ------------------------------------------------
concurrency: ## Máximo de tareas simultáneas en la última ejecución
	@test -f $(TRACE) || { echo "No hay traza: ejecuta antes make clean y un build"; exit 1; }
	@awk '/^start/ {n++; if (n > m) m = n} /^end/ {n--} END {print "Máximo simultáneo: " m}' $(TRACE)

clean: ## Borra la traza
	@rm -f -- '$(TRACE)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
