# ============================================================
# Lab 01 — Anatomía del .d
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run clean help FORCE
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
# TODO (paso 5): -Iinclude es una flag del preprocesador. Muévela a CPPFLAGS
#   y añade $(CPPFLAGS) a la receta de compilación.
CFLAGS := -Wall -Wextra -std=c11 -Iinclude
# TODO (pasos 2 y 4): DEPFLAGS con -MMD (paso 2) y después -MP (paso 4)

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
APP       := $(BUILD_DIR)/app
SRCS      := $(wildcard $(SRC_DIR)/*.c)
OBJS      := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
# TODO (paso 2): DEPS, un .d por objeto: $(OBJS:.o=.d)
# TODO (paso 6): FLAGS_STAMP := $(BUILD_DIR)/compile-flags.txt

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS)
	$(CC) $^ -o $@

# TODO (paso 6): añade $(FLAGS_STAMP) como prerrequisito, DESPUÉS del .c
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

# TODO (paso 6): regla del stamp. Depende de FORCE y solo reescribe el archivo
#   si el comando de compilación cambió:
#   @mkdir -p $(@D)
#   @echo '$(CC) $(CPPFLAGS) $(CFLAGS)' | cmp -s - $@ || echo '$(CC) $(CPPFLAGS) $(CFLAGS)' > $@

# TODO (paso 7): que un cambio en este Makefile recompile los objetos,
#   sin que el Makefile aparezca en $^:  $(OBJS): .EXTRA_PREREQS := Makefile

# TODO (paso 2): carga los .d con -include (con guion: la primera vez no existen)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
