# ============================================================
# Lab 01 — Anatomía del .d (SOLUCIÓN)
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run clean help FORCE
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC       := gcc
# Preprocesador (-I, -D): sobrevive a un CFLAGS=... desde la línea de comandos
CPPFLAGS := -Iinclude
CFLAGS   := -Wall -Wextra -std=c11
# -MMD: escribe x.d con los headers del proyecto que incluye x.c
# -MP:  añade "header:" vacío por cada uno, para poder borrar headers
DEPFLAGS := -MMD -MP

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
APP       := $(BUILD_DIR)/app
SRCS      := $(wildcard $(SRC_DIR)/*.c)
OBJS      := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPS      := $(OBJS:.o=.d)
FLAGS_STAMP := $(BUILD_DIR)/compile-flags.txt

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS)
	$(CC) $^ -o $@

# $< sigue siendo el .c: el stamp va detrás
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(FLAGS_STAMP)
	@mkdir -p $(@D)
	$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# FORCE ejecuta la receta siempre; cmp evita reescribir si nada cambió,
# así la fecha del stamp solo avanza cuando cambian las flags
$(FLAGS_STAMP): FORCE
	@mkdir -p $(@D)
	@echo '$(CC) $(CPPFLAGS) $(CFLAGS)' | cmp -s - $@ || echo '$(CC) $(CPPFLAGS) $(CFLAGS)' > $@

# Editar el Makefile recompila; .EXTRA_PREREQS no aparece en $^ ni en $<
$(OBJS): .EXTRA_PREREQS := Makefile

-include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
