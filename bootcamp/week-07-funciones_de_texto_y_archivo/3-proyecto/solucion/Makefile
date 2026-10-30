# ============================================================
# Proyecto Semana 07 — Build multi-módulo auto-configurable (SOLUCIÓN)
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build clean manifest report objs help
.DEFAULT_GOAL := help

CC    := gcc
BUILD := build

# --- Descubrimiento (lo único que mira el disco) ---
# src/app.c src/main.c
CORE_SRCS   := $(wildcard src/*.c)
# modules/auth/auth.c modules/config/config.c modules/logger/logger.c
MODULE_SRCS := $(wildcard modules/*/*.c)

# --- Derivadas (solo texto) ---
ALL_SRCS    := $(CORE_SRCS) $(MODULE_SRCS)
# src/main.c -> build/src/main.o ; modules/auth/auth.c -> build/modules/auth/auth.o
OBJS        := $(patsubst %.c,$(BUILD)/%.o,$(ALL_SRCS))
# modules/auth/ modules/config/ modules/logger/  (sort: ordena y quita repetidos)
MODULE_DIRS := $(sort $(dir $(MODULE_SRCS)))
# auth config logger  ($(notdir modules/auth/) sería vacío: primero se quita la /)
MODULES     := $(notdir $(patsubst %/,%,$(MODULE_DIRS)))
CFLAGS      := -Wall -Wextra -std=c11 $(addprefix -I,$(MODULE_DIRS))
TARGET      := $(BUILD)/sistema

# Módulo pedido en 'make objs MODULE=...'; strip quita espacios accidentales
MODULE ?=
MOD    := $(strip $(MODULE))

all: build ## Compila el sistema completo

build: $(TARGET) ## Enlaza el programa final

$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Sistema compilado: $@"

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

manifest: ## Genera build/manifest.txt con lista de fuentes
	@mkdir -p $(BUILD)
	@echo "# Fuentes del proyecto" > $(BUILD)/manifest.txt
	@printf '%s\n' $(ALL_SRCS) >> $(BUILD)/manifest.txt
	@echo "Manifest generado: $(BUILD)/manifest.txt ($(words $(ALL_SRCS)) fuentes)"

report: ## Muestra estadísticas del proyecto usando funciones de texto
	@echo "=== Reporte del Proyecto ==="
	@echo "Fuentes core:    $(words $(CORE_SRCS)) archivos ($(notdir $(CORE_SRCS)))"
	@echo "Fuentes módulos: $(words $(MODULE_SRCS)) archivos"
	@echo "Directorios:     $(MODULE_DIRS)"
	@echo "Módulos:         $(MODULES)"
	@echo "Target:          $(notdir $(basename $(TARGET)))"
	@echo "Total objetos:   $(words $(OBJS))"

objs: ## Lista los objetos de un módulo (MODULE=auth)
	$(if $(filter $(MOD),$(MODULES)),,$(error Módulo '$(MOD)' no existe; disponibles: $(MODULES)))
	@echo "$(filter $(BUILD)/modules/$(MOD)/%,$(OBJS))"

clean: ## Elimina archivos generados
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
