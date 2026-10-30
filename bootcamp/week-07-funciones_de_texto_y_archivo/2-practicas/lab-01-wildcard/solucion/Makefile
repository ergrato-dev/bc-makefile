# ============================================================
# Lab 01 — wildcard (SOLUCIÓN)
# Semana 07: Funciones de texto y archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build clean list-sources list-dirs help
.DEFAULT_GOAL := help

CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11
SRC_DIR := src
BUILD   := build
TARGET  := $(BUILD)/programa

SRCS   := $(wildcard $(SRC_DIR)/*.c)
OBJS   := $(patsubst $(SRC_DIR)/%.c,$(BUILD)/%.o,$(SRCS))
# $(wildcard) de un solo archivo = prueba de existencia (vacío si no está)
LOGGER := $(wildcard $(SRC_DIR)/logger.c)

all: build ## Alias para build

list-sources: ## Muestra las fuentes y objetos descubiertos automáticamente
	$(if $(SRCS),,$(error No hay fuentes .c en $(SRC_DIR)/))
	@echo "SRCS   = $(SRCS)"
	@echo "OBJS   = $(OBJS)"
	@echo "Total  = $(words $(SRCS)) archivos"
	@echo "Logger = $(if $(LOGGER),presente,ausente)"

list-dirs: ## Muestra los directorios únicos de los objetos (reto extra)
	@echo "Dirs  = $(sort $(dir $(OBJS)))"

build: $(TARGET) ## Compila el programa

$(TARGET): $(OBJS)
	$(if $(SRCS),,$(error No hay fuentes .c en $(SRC_DIR)/))
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Compilado: $@"

$(BUILD)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina archivos de compilación
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
