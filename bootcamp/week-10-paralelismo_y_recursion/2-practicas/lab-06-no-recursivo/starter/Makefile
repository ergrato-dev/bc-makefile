# ============================================================
# Lab 06 — Make no recursivo
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean run help
.DEFAULT_GOAL := help

# --- Toolchain -----------------------------------------------
CC       := cc
CFLAGS   := -Wall -Wextra -std=c11
CPPFLAGS := -MMD -MP
BUILD_DIR := build

# --- Módulos -------------------------------------------------
# Un module.mk por directorio, incluidos en ESTE Make: un solo grafo
# con todas las reglas, un solo jobserver y ningún sub-make.
# El orden importa: app usa $(LIB), que define lib.
MODULES := lib app
OBJS    :=
# TODO 1: incluye el module.mk de cada módulo de MODULES, en orden.
#         Tip: $(addsuffix /module.mk,$(MODULES))

# --- Build ---------------------------------------------------
all: $(APP) ## Construye la librería y el ejecutable

# Una regla de compilación para todos los módulos.
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(@D)
	@echo "[cc] $<"
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# TODO 3: incluye los .d que genera -MMD (uno por objeto de OBJS).
#         Con guion: en el primer build todavía no existen.

run: $(APP) ## Ejecuta el programa
	@./$(APP)

# --- Utilidades ----------------------------------------------
clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
