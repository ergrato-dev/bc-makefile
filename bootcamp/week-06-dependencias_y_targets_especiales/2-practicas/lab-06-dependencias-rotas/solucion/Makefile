# ============================================================
# Lab 06 — Dependencias rotas (SOLUCIÓN)
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================
# Este Makefile tiene CINCO bugs (A-E). Ninguno es de sintaxis: todos son de
# dependencias. Lee la tabla del README, reproduce cada síntoma y corrige el
# bug con el cambio mínimo, dejando un comentario "# FIX X:" que explique por
# qué fallaba.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run clean help
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
# FIX B: sin -MP, el .d dice que util.o necesita include/obsoleto.h. Al borrar
#   el header, Make no sabe crearlo y para. -MP añade "include/obsoleto.h:" vacío.
DEPFLAGS := -MMD -MP

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
GEN_DIR   := $(BUILD_DIR)/gen
APP       := $(BUILD_DIR)/app
CPPFLAGS  := -Iinclude -I$(GEN_DIR)

# ── Código generado ──────────────────────────────────────────
GEN_TOOL := tools/gen-info.sh
GEN_C    := $(GEN_DIR)/build_info.c
GEN_H    := $(GEN_DIR)/build_info.h

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o) $(GEN_C:.c=.o)
DEPS := $(OBJS:.o=.d)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS)
	@echo "[link] $@"
	@$(CC) $^ -o $@

# FIX C: build/ era prerrequisito normal. Cada archivo nuevo en build/ (el
#   propio binario) cambia su fecha y deja todos los objetos "viejos". El
#   directorio solo tiene que existir: order-only.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(GEN_DIR)/%.o: $(GEN_DIR)/%.c
	@echo "[cc]   $<"
	@$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# FIX E: en el primer build no hay .d, así que nada decía que main.o necesita
#   build_info.h y gcc compilaba main.c antes de generarlo. Order-only: el header
#   existe antes de compilar, y después el .d decide quién se recompila.
$(OBJS): | $(GEN_H)

# FIX D: con ':' eran dos reglas independientes con la misma receta, y con -j
#   el generador corría dos veces a la vez. '&:' = una ejecución, dos archivos.
$(GEN_C) $(GEN_H) &: VERSION $(GEN_TOOL) | $(GEN_DIR)
	@bash $(GEN_TOOL) VERSION $(GEN_DIR)

$(BUILD_DIR) $(GEN_DIR):
	@mkdir -p $@

# FIX A: sin guion, Make exige que los .d existan antes de leer el resto, y
#   en el primer build no existen: ni siquiera 'make help' funcionaba.
-include $(DEPS)

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
