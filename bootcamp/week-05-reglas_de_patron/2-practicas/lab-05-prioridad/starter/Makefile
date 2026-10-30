# ============================================================
# Lab 05 — Cómo elige Make una regla
# Semana 05: Reglas de patrón
# ============================================================
# Sigue los pasos del README en orden; cada TODO dice su paso.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# TODO (paso 6): desactiva las reglas implícitas de serie
#   MAKEFLAGS += -r

.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

OBJS := main.o normal.o debug.o
APP  := app

all: $(APP) ## Compila la aplicación

$(APP): $(OBJS)
	$(CC) $^ -o $@

# Regla de patrón general: ya está escrita
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "[patrón %] $@ stem=$*"

# TODO (paso 4): regla de patrón test_%.o: test_%.c
#   Receta: $(CC) $(CFLAGS) -DTEST -c $< -o $@
#           @echo "[patrón test_%] $@ stem=$*"

# TODO (paso 2): regla EXPLÍCITA debug.o: debug.c
#   Receta: $(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
#           @echo "[explícita] $@ compilado con -g -DDEBUG"

# TODO (paso 3): normal.o depende de config.h (una línea, SIN receta)

clean: ## Elimina objetos y binarios
	rm -f -- *.o $(APP) main

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
