# ============================================================
# Lab 03 — vpath: fuentes repartidos en varios directorios
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run clean help
.DEFAULT_GOAL := help

CC       := gcc
CPPFLAGS := -Iinclude
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD -MP

BUILD_DIR := build
APP       := $(BUILD_DIR)/app
# Solo nombres: dónde está cada uno lo resuelve vpath
SRC_NAMES := main.c calc.c fmt.c
OBJS      := $(SRC_NAMES:%.c=$(BUILD_DIR)/%.o)
DEPS      := $(OBJS:.o=.d)

# TODO (paso 2): indica a Make dónde buscar los .c: src, src/core y src/util
# TODO (paso 4): prueba vpath %.h include (y entiende por qué no sustituye a -I)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS) | $(BUILD_DIR)
	@echo "[link] $@"
	@$(CC) $^ -o $@

# El prerrequisito %.c no lleva ruta: la encuentra vpath, y $< la incluye
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	@mkdir -p $@

-include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
