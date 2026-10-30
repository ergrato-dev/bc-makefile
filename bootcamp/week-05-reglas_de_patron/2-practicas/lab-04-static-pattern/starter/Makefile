# ============================================================
# Lab 04 — Static pattern rules
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Define LIB_OBJS y APP_OBJS como listas separadas
#   2. Static pattern rule para LIB_OBJS → build/lib/ (con -fPIC)
#   3. Static pattern rule para APP_OBJS → build/main/
#   4. Empaqueta LIB_OBJS en build/libops.a y enlaza la app
#   5. Verifica con: make all && ./build/calculator
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC         := gcc
CFLAGS     := -Wall -std=c11
LIB_CFLAGS := -fPIC
AR         := ar

# ── Rutas ─────────────────────────────────────────────────────
INC_DIR := include
BUILD   := build

# ── Listas de fuentes separadas ───────────────────────────────
LIB_SRCS := src/math_ops.c src/string_ops.c
APP_SRCS := src/main.c

# TODO: transforma LIB_SRCS → $(BUILD)/lib/%.o
LIB_OBJS :=

# TODO: transforma APP_SRCS → $(BUILD)/main/%.o
APP_OBJS :=

LIB := $(BUILD)/libops.a
APP := $(BUILD)/calculator

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la librería y la aplicación

# TODO: receta $(CC) $^ -o $@
$(APP): $(APP_OBJS) $(LIB)

# TODO: receta $(AR) rcs $@ $^
$(LIB): $(LIB_OBJS)

# TODO: static pattern rule para LIB_OBJS
#   $(LIB_OBJS): $(BUILD)/lib/%.o: src/%.c
#   	@mkdir -p $(@D)
#   	$(CC) $(CFLAGS) $(LIB_CFLAGS) -I$(INC_DIR) -c $< -o $@

# TODO: static pattern rule para APP_OBJS (sin LIB_CFLAGS)
#   $(APP_OBJS): $(BUILD)/main/%.o: src/%.c

clean: ## Elimina build/
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
