SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build clean list-sources list-dirs help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/programa

SRCS := $(wildcard src/*.c)
OBJS := $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))

all: build ## Alias para build

list-sources: ## Muestra las fuentes y objetos descubiertos automáticamente
	@echo "SRCS  = $(SRCS)"
	@echo "OBJS  = $(OBJS)"
	@echo "Total = $(words $(SRCS)) archivos"

list-dirs: ## Muestra los directorios únicos de los objetos (reto extra)
	@echo "Dirs  = $(sort $(dir $(OBJS)))"

build: $(TARGET) ## Compila el programa

$(TARGET): $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Compilado: $@"

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina archivos de compilación
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
