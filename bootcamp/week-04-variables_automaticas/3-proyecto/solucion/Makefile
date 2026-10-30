# ============================================================
# Proyecto Semana 04 — Solución: Build system C multi-archivo
# ============================================================

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -std=c11
LDFLAGS :=

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
INC_DIR   := include
APP       := $(BUILD_DIR)/app

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

## all: compila el proyecto completo
all: $(APP)

# $^ = todos los .o (el linker los necesita todos)
# $@ = ruta del binario final
$(APP): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	@echo "[link] $@ listo."

# $<    = el único .c fuente (gcc -c toma un solo fuente)
# $@    = la ruta del .o de salida
# $(@D) = el directorio del .o (build/); mkdir -p lo crea si no existe
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@
	@echo "[cc]   $< → $@"

## clean: elimina todos los artefactos de build
clean:
	@rm -rf $(BUILD_DIR)
	@echo "[clean] Listo."

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [CC=compilador] [CFLAGS=flags]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
