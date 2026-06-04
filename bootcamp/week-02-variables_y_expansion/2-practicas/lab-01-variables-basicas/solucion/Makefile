# ============================================================
# Lab 01 — Variables básicas (SOLUCIÓN)
# ============================================================

.PHONY: info-compilador info-entorno info-libs help

.DEFAULT_GOAL := help

# ── Compilador ───────────────────────────────────────────────
CC     := gcc
CFLAGS  = -Wall -Wextra -std=c11

# ── Entorno ───────────────────────────────────────────────────
ENV    ?= dev

# ── Bibliotecas ───────────────────────────────────────────────
LIBS   := -lm
LIBS   += -lpthread

## info-compilador: imprime CC y CFLAGS
info-compilador:
	@echo "CC:     $(CC)"
	@echo "CFLAGS: $(CFLAGS)"

## info-entorno: imprime el entorno actual
info-entorno:
	@echo "Entorno: $(ENV)"

## info-libs: imprime las bibliotecas enlazadas
info-libs:
	@echo "LIBS: $(LIBS)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|prod]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
