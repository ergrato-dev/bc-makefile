# ============================================================
# Lab 04 — Grouped targets: un generador, dos archivos
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.SECONDEXPANSION:

.PHONY: all run clean help
.DEFAULT_GOAL := help

CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD -MP

BUILD_DIR := build
GEN_DIR   := $(BUILD_DIR)/gen
APP       := $(BUILD_DIR)/app
# Después de GEN_DIR: con := se expande ya, y antes valdría vacío
CPPFLAGS  := -I$(GEN_DIR)

# tools/gen-tabla.sh defs/colores.def build/gen → colores.c Y colores.h
GEN_TOOL := tools/gen-tabla.sh
GEN_DEF  := defs/colores.def
GEN_C    := $(GEN_DIR)/colores.c
GEN_H    := $(GEN_DIR)/colores.h

OBJS := $(BUILD_DIR)/main.o $(GEN_DIR)/colores.o
DEPS := $(OBJS:.o=.d)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS) | $$(@D)/
	@echo "[link] $@"
	@$(CC) $^ -o $@

$(BUILD_DIR)/%.o: src/%.c | $$(@D)/
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(GEN_DIR)/%.o: $(GEN_DIR)/%.c | $$(@D)/
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# El header generado debe existir antes de compilar (lab 06 explica por qué)
$(OBJS): | $(GEN_H)

# TODO (paso 4): esta regla parece "una regla con dos targets", pero para Make
#   son DOS reglas independientes que comparten receta. Conviértela en un
#   grouped target.
$(GEN_C) $(GEN_H): $(GEN_DEF) $(GEN_TOOL) | $(GEN_DIR)/
	@bash $(GEN_TOOL) $(GEN_DEF) $(GEN_DIR)

%/:
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
