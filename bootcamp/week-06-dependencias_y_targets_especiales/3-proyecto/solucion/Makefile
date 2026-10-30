# ============================================================
# Proyecto Semana 06 — Build C con dependencias de headers exactas
# (SOLUCIÓN)
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
# $$(@D) en los prerrequisitos necesita una segunda expansión
.SECONDEXPANSION:

.PHONY: all clean help FORCE
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
# Dependencias automáticas: un .d junto a cada .o, con reglas vacías por header
DEPFLAGS := -MMD -MP

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
GEN_DIR   := $(BUILD_DIR)/gen
APP       := $(BUILD_DIR)/app
# Preprocesador: dónde buscar headers (los escritos a mano y los generados)
CPPFLAGS  := -Iinclude -I$(GEN_DIR)

# ── Código generado ──────────────────────────────────────────
GEN_TOOL := tools/gen-version.sh
GEN_C    := $(GEN_DIR)/version.c
GEN_H    := $(GEN_DIR)/version.h

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o) $(GEN_C:.c=.o)
DEPS := $(OBJS:.o=.d)

# Cambia si cambian el compilador o las flags: todos los objetos dependen de él
FLAGS_STAMP := $(BUILD_DIR)/compile-flags.txt
COMPILE_CMD := $(CC) $(CPPFLAGS) $(CFLAGS)

all: $(APP) ## Compila build/app de forma incremental

# ── Enlace ────────────────────────────────────────────────────
$(APP): $(OBJS)
	@$(CC) $^ -o $@
	@echo "[link] $@"

# ── Compilación ───────────────────────────────────────────────
# Prerrequisitos normales: el fuente ($<) y el stamp de flags.
# Order-only: el directorio del objeto. Crearlo o tocarlo no recompila nada.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(FLAGS_STAMP) | $$(@D)/
	@$(COMPILE_CMD) $(DEPFLAGS) -c $< -o $@
	@echo "[cc]   $<"

# Mismo trabajo para el código generado, que vive en build/gen/
$(GEN_DIR)/%.o: $(GEN_DIR)/%.c $(FLAGS_STAMP) | $$(@D)/
	@$(COMPILE_CMD) $(DEPFLAGS) -c $< -o $@
	@echo "[cc]   $<"

# El header generado tiene que existir antes de compilar nada (en el primer
# build aún no hay .d que lo diga). Order-only: después manda el .d, y solo
# se recompila quien de verdad lo incluye.
$(OBJS): | $(GEN_H)

# ── Generador ─────────────────────────────────────────────────
# Grouped target (&:): una ejecución produce los dos archivos.
# Sin &, con -j Make lanzaría el generador una vez por archivo.
$(GEN_C) $(GEN_H) &: $(GEN_TOOL) VERSION | $(GEN_DIR)/
	@bash $(GEN_TOOL) VERSION $(GEN_DIR)

# ── Stamp de flags ────────────────────────────────────────────
# Se evalúa siempre (FORCE), pero solo reescribe el archivo si las flags
# cambiaron: si no cambia su fecha, nadie se recompila.
$(FLAGS_STAMP): FORCE | $$(@D)/
	@echo '$(COMPILE_CMD)' | cmp -s - $@ || echo '$(COMPILE_CMD)' > $@

# Cualquier directorio de salida: build/, build/core/, build/gen/ ...
%/:
	@mkdir -p $@

# Los directorios los crea una regla de patrón: para Make son intermedios y
# Make 4.3 intentaría borrarlos al terminar. .PRECIOUS acepta patrones.
.PRECIOUS: %/

# Con guion: en el primer build todavía no hay ningún .d
-include $(DEPS)

clean: ## Elimina build/ completo
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD_DIR)'
	@echo "[clean] listo"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
