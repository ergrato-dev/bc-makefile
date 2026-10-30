# ============================================================
# Lab 02 — Regla de patrón con directorio de salida (SOLUCIÓN)
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

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
INC_DIR   := include

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(SRC_DIR)/main.c $(SRC_DIR)/utils.c
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
APP  := $(BUILD_DIR)/app

# ── Targets ───────────────────────────────────────────────────
all: $(APP) ## Compila la aplicación completa

$(APP): $(OBJS)
	$(CC) $^ -o $@

# El stem puede llevar barras: build/net/ping.o → stem net/ping
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	@echo "[cc] stem=$* dir=$(@D)"
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

clean: ## Elimina el directorio build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
