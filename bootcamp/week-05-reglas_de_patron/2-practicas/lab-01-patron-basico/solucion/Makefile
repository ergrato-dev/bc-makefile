# ============================================================
# Lab 01 — Regla de patrón %.o: %.c (SOLUCIÓN)
# Semana 05: Reglas de patrón
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -std=c11

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := main.c math.c greet.c
OBJS := $(SRCS:.c=.o)
APP  := app

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la aplicación completa

$(APP): $(OBJS)
	$(CC) $^ -o $@

# Una sola regla para todos los .o: $* es el stem, $< el .c, $@ el .o
%.o: %.c
	@echo "[cc] stem=$*"
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina objetos y binario
	rm -f -- $(OBJS) $(APP)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
