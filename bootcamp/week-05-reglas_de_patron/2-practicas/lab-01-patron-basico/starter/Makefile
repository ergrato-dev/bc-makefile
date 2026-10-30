# ============================================================
# Lab 01 — Regla de patrón %.o: %.c
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Define OBJS derivando la lista de .c a .o
#   2. Escribe la regla de patrón %.o: %.c con variables automáticas
#   3. Completa el target 'app' para enlazar todos los objetos
#   4. Verifica con: make app && ./app
# ============================================================

# TODO: preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -std=c11

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := main.c math.c greet.c
# TODO: define OBJS transformando cada .c en .o
#       Pista: $(SRCS:.c=.o)
OBJS :=
APP  := app

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la aplicación completa

# TODO: receta que enlace $^ y genere $@ con $(CC)
$(APP): $(OBJS)

# TODO: escribe la regla de patrón %.o: %.c
#       Receta (dos líneas):
#         @echo "[cc] stem=$*"
#         $(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina objetos y binario
	rm -f -- $(OBJS) $(APP)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
