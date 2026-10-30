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

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

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
APP  := $(BUILD_DIR)/app

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la aplicación completa

# TODO: receta que enlace $^ y genere $@ con $(CC)
$(APP): $(OBJS)

# TODO: regla de patrón $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c con tres líneas:
#         @mkdir -p $(@D)
#         @echo "[cc] stem=$* dir=$(@D)"
#         $(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

clean: ## Elimina el directorio build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
