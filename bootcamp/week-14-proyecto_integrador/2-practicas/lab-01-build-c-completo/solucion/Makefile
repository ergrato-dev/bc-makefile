SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean info run help
.DEFAULT_GOAL := help

CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11 -Iinclude
LDFLAGS :=

SRC_DIR   := src
BUILD_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

-include $(DEPS)

TARGET := $(BUILD_DIR)/app

all: $(TARGET) ## Compilar el proyecto completo

$(TARGET): $(OBJS) | $(BUILD_DIR)
	@echo "Enlazando $@ ..."
	$(CC) $(LDFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@echo "Compilando $< ..."
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

run: all ## Ejecutar el binario compilado
	@$(TARGET)

clean: ## Eliminar artefactos de build
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

info: ## Mostrar fuentes y objetos calculados
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "DEPS = $(DEPS)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
