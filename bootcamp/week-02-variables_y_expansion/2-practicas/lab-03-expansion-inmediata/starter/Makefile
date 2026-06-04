# ============================================================
# Lab 03 — Expansión inmediata: capturar valores de shell
# Semana 02: Variables y Expansión en Make
# ============================================================
# Objetivo: ver la diferencia entre = y := con $(shell ...)
# ============================================================

.PHONY: comparar git-info help

.DEFAULT_GOAL := help

# ── Timestamps ───────────────────────────────────────────────
# TODO: define TIMESTAMP_LAZY con = capturando $(shell date +%T)
#       (el comando se ejecuta CADA VEZ que se usa la variable)
# TIMESTAMP_LAZY = ...

# TODO: define TIMESTAMP_EAGER con := capturando $(shell date +%T)
#       (el comando se ejecuta UNA SOLA VEZ al cargar el Makefile)
# TIMESTAMP_EAGER := ...

# ── Información de git ────────────────────────────────────────
# TODO: define GIT_HASH con := capturando el hash corto del commit actual
#       Si no hay repositorio git, debe imprimir "no-git"
#       Pista: $(shell git rev-parse --short HEAD 2>/dev/null || echo "no-git")
# GIT_HASH := ...

# TODO: define VERSION con := en formato "0.1.0-$(GIT_HASH)"
# VERSION := ...

## comparar: imprime cada timestamp dos veces para ver si cambia
comparar:
	@echo "--- Con = (lazy, se re-ejecuta) ---"
	# TODO: @echo "  Primera lectura:  $(TIMESTAMP_LAZY)"
	# TODO: @echo "  Segunda lectura:  $(TIMESTAMP_LAZY)"
	@echo "--- Con := (eager, capturado una vez) ---"
	# TODO: @echo "  Primera lectura:  $(TIMESTAMP_EAGER)"
	# TODO: @echo "  Segunda lectura:  $(TIMESTAMP_EAGER)"

## git-info: imprime hash de git y versión del proyecto
git-info:
	# TODO: @echo "Git hash: $(GIT_HASH)"
	# TODO: @echo "Versión:  $(VERSION)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [comparar|git-info]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
