# ============================================================
# Lab 06 — Dependencias rotas (lab de depuración)
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================
# Este Makefile tiene CINCO bugs (A-E). Ninguno es de sintaxis: todos son de
# dependencias. Lee la tabla del README, reproduce cada síntoma y corrige el
# bug con el cambio mínimo, dejando un comentario "# FIX X:" que explique por
# qué fallaba.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run clean help
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
GEN_DIR   := $(BUILD_DIR)/gen
APP       := $(BUILD_DIR)/app
CPPFLAGS  := -Iinclude -I$(GEN_DIR)

# ── Código generado ──────────────────────────────────────────
GEN_TOOL := tools/gen-info.sh
GEN_C    := $(GEN_DIR)/build_info.c
GEN_H    := $(GEN_DIR)/build_info.h

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o) $(GEN_C:.c=.o)
DEPS := $(OBJS:.o=.d)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS)
	@echo "[link] $@"
	@$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(BUILD_DIR)
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(GEN_DIR)/%.o: $(GEN_DIR)/%.c
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(GEN_C) $(GEN_H): VERSION $(GEN_TOOL) | $(GEN_DIR)
	@bash $(GEN_TOOL) VERSION $(GEN_DIR)

$(BUILD_DIR) $(GEN_DIR):
	@mkdir -p $@

include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
