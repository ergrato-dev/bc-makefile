# ============================================================
# Lab 01 — wildcard
# Semana 07: Funciones de texto y archivo
# ============================================================

# TODO (paso 4): preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all build clean list-sources help
.DEFAULT_GOAL := help

CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11
SRC_DIR := src
BUILD   := build
TARGET  := $(BUILD)/programa

# TODO (paso 4): reemplaza esta lista hardcodeada con $(wildcard $(SRC_DIR)/*.c)
SRCS := src/main.c src/calc.c src/io.c

# TODO (paso 5): reemplaza esta lista con $(patsubst $(SRC_DIR)/%.c,$(BUILD)/%.o,$(SRCS))
OBJS := $(BUILD)/main.o $(BUILD)/calc.o $(BUILD)/io.o

# TODO (paso 8): LOGGER := $(wildcard $(SRC_DIR)/logger.c)

all: build ## Alias para build

# TODO (paso 7): primera línea de la receta = guarda que falla si SRCS está vacía
# TODO (paso 8): añade la línea "Logger = presente|ausente" con $(if $(LOGGER),...)
list-sources: ## Muestra las fuentes y objetos detectados
	@echo "SRCS   = $(SRCS)"
	@echo "OBJS   = $(OBJS)"
	@echo "Total  = $(words $(SRCS)) archivos"

build: $(TARGET) ## Compila el programa

$(TARGET): $(OBJS)
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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
