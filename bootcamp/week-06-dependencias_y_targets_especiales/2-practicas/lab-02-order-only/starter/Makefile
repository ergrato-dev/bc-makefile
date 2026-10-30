# ============================================================
# Lab 02 — Order-only y directorios de salida
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
# TODO (paso 5): activa la segunda expansión para usar $$(@D) en prerrequisitos

.PHONY: all run clean help
.DEFAULT_GOAL := help

CC       := gcc
CPPFLAGS := -Iinclude
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD -MP

SRC_DIR   := src
BUILD_DIR := build
APP       := $(BUILD_DIR)/app
# TODO (paso 5): incluye también los fuentes de un nivel más: $(SRC_DIR)/*/*.c
SRCS      := $(wildcard $(SRC_DIR)/*.c)
OBJS      := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPS      := $(OBJS:.o=.d)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

# TODO (paso 3): el directorio no debe ser un prerrequisito normal del binario
$(APP): $(OBJS) $(BUILD_DIR)
	@echo "[link] $@"
	@$(CC) $(OBJS) -o $@

# TODO (paso 3): ni de los objetos. Pásalo a order-only con |
# TODO (paso 5): sustituye $(BUILD_DIR) por el directorio de cada objeto: $$(@D)/
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(BUILD_DIR)
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# TODO (paso 5): sustituye esta regla por una regla de patrón %/ que cree
#   cualquier directorio, y protégela con .PRECIOUS: %/
$(BUILD_DIR):
	@echo "[mkdir] $@"
	@mkdir -p $@

-include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
