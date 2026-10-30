# ============================================================
# Lab 02 — Regla de patrón con directorio de salida
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Define OBJS transformando rutas src/*.c → build/*.o
#   2. Escribe la regla build/%.o: src/%.c con mkdir -p $(@D)
#   3. Completa el target $(APP) para enlazar desde build/
#   4. Verifica con: make all && ./build/app
# ============================================================

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -std=c11

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
INC_DIR   := include

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(SRC_DIR)/main.c $(SRC_DIR)/utils.c
# TODO: define OBJS transformando cada src/%.c en build/%.o
#       Pista: $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
OBJS :=

APP := $(BUILD_DIR)/app

# ── Targets ───────────────────────────────────────────────────

## all: compila la aplicación completa
all: $(APP)

## $(APP): enlaza todos los objetos
$(APP): $(OBJS)
	# TODO: enlaza $^ y genera $@ con $(CC)

# TODO: escribe la regla de patrón build/%.o: src/%.c
#       - usa @mkdir -p $(@D) para crear el directorio
#       - compila con $(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

## clean: elimina el directorio build/
clean:
	@rm -rf $(BUILD_DIR)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
