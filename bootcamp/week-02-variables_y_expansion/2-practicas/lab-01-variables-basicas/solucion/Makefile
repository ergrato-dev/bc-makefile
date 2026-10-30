# ============================================================
# Lab 01 — Variables básicas (SOLUCIÓN)
# ============================================================

.PHONY: info-compilador info-entorno info-libs tipos help

.DEFAULT_GOAL := help

# ── Compilador ───────────────────────────────────────────────
CC     := gcc
CFLAGS  = -Wall -Wextra -std=c11

# ── Entorno ───────────────────────────────────────────────────
ENV    ?= dev

# ── Bibliotecas ───────────────────────────────────────────────
LIBS   := -lm
LIBS   += -lpthread

info-compilador: ## imprime CC y CFLAGS
	@echo "CC:     $(CC)"
	@echo "CFLAGS: $(CFLAGS)"

info-entorno: ## imprime el entorno actual
	@echo "Entorno: $(ENV)"

info-libs: ## imprime las bibliotecas enlazadas
	@echo "LIBS: $(LIBS)"

tipos: ## muestra el sabor (flavor) de cada variable
	@echo "CC:     $(flavor CC)"
	@echo "CFLAGS: $(flavor CFLAGS)"
	@echo "ENV:    $(flavor ENV)"
	@echo "LIBS:   $(flavor LIBS)"
	@echo "NADA:   $(flavor NADA)"

help: ## muestra esta ayuda
	@echo "Uso: make [target] [ENV=dev|prod]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
