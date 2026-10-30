# ============================================================
# Lab 04 — Static pattern rules (SOLUCIÓN)
# Semana 05: Reglas de patrón
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

LIB_OBJS := $(LIB_SRCS:src/%.c=$(BUILD)/lib/%.o)
APP_OBJS := $(APP_SRCS:src/%.c=$(BUILD)/main/%.o)

LIB := $(BUILD)/libops.a
APP := $(BUILD)/calculator

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la librería y la aplicación

$(APP): $(APP_OBJS) $(LIB)
	$(CC) $^ -o $@

$(LIB): $(LIB_OBJS)
	$(AR) rcs $@ $^

# Solo los objetos de LIB_OBJS, con -fPIC
$(LIB_OBJS): $(BUILD)/lib/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(LIB_CFLAGS) -I$(INC_DIR) -c $< -o $@

# Solo los objetos de APP_OBJS, sin -fPIC
$(APP_OBJS): $(BUILD)/main/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

clean: ## Elimina build/
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
