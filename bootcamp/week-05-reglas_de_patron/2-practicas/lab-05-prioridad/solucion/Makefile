# ============================================================
# Lab 05 — Cómo elige Make una regla (SOLUCIÓN)
# Semana 05: Reglas de patrón
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# Paso 6: sin reglas implícitas de serie
MAKEFLAGS += -r

.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

OBJS := main.o normal.o debug.o
APP  := app

all: $(APP) ## Compila la aplicación

$(APP): $(OBJS)
	$(CC) $^ -o $@

# Regla de patrón general
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "[patrón %] $@ stem=$*"

# Paso 4: más específica (stem más corto) → gana para test_*.o
test_%.o: test_%.c
	$(CC) $(CFLAGS) -DTEST -c $< -o $@
	@echo "[patrón test_%] $@ stem=$*"

# Paso 2: regla explícita CON receta → gana a cualquier patrón
debug.o: debug.c
	$(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
	@echo "[explícita] $@ compilado con -g -DDEBUG"

# Paso 3: SIN receta → solo añade un prerrequisito; el patrón sigue mandando
normal.o: config.h

clean: ## Elimina objetos y binarios
	rm -f -- *.o $(APP) main

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
