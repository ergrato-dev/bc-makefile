# ============================================================
# Lab 02 — Order-only y directorios de salida (SOLUCIÓN)
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
# Segunda expansión: $$(@D) en prerrequisitos vale el directorio de cada target
.SECONDEXPANSION:

.PHONY: all run clean help
.DEFAULT_GOAL := help

CC       := gcc
CPPFLAGS := -Iinclude
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD -MP

SRC_DIR   := src
BUILD_DIR := build
APP       := $(BUILD_DIR)/app
SRCS      := $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*/*.c)
OBJS      := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPS      := $(OBJS:.o=.d)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

# Sin el directorio como prerrequisito normal, $^ vuelve a ser solo objetos
$(APP): $(OBJS) | $$(@D)/
	@echo "[link] $@"
	@$(CC) $^ -o $@

# Normal: el fuente (su fecha cuenta). Order-only: el directorio (solo existir)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $$(@D)/
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Cualquier directorio de salida. Lo crea una regla de patrón, así que para
# Make es intermedio: .PRECIOUS impide que Make 4.3 intente borrarlo al final
%/:
	@echo "[mkdir] $@"
	@mkdir -p $@
.PRECIOUS: %/

-include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
