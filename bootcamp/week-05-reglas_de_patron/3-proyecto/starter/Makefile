# ============================================================
# Proyecto — Compilador genérico para proyectos C
# Semana 05: Reglas de patrón
# ============================================================
# Entregables:
#   - build/app: binario principal
#   - build/test_runner: binario de tests
#   - build/asm/*.s: ensamblador de cada módulo
# Targets requeridos: all, test, asm, clean, help
# ============================================================

# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

# TODO: desactiva las reglas implícitas de serie (1-teoria/02-reglas-implicitas.md):
#   MAKEFLAGS += -r

.PHONY: all test asm clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -std=c11

# ── Directorios ───────────────────────────────────────────────
SRC_DIR  := src
INC_DIR  := include
TEST_DIR := tests
BUILD    := build
OBJ_DIR  := $(BUILD)/obj
TST_DIR  := $(BUILD)/test
ASM_DIR  := $(BUILD)/asm

# ── Fuentes ───────────────────────────────────────────────────
# TODO: usa $(wildcard ...) para encontrar todos los .c en SRC_DIR
SRCS :=

# TODO: excluye main.c de los módulos de librería y define LIB_SRCS
LIB_SRCS :=

# TODO: define APP_SRCS solo con src/main.c
APP_SRCS :=

# TODO: define TEST_SRCS con todos los .c en TEST_DIR
TEST_SRCS :=

# ── Objetos y derivados ───────────────────────────────────────
# TODO: define LIB_OBJS transformando LIB_SRCS → OBJ_DIR/%.o
LIB_OBJS :=

# TODO: define APP_OBJS transformando APP_SRCS → OBJ_DIR/%.o
APP_OBJS :=

# TODO: define TEST_OBJS transformando TEST_SRCS → TST_DIR/%.o
TEST_OBJS :=

# TODO: define ASMS transformando SRCS → ASM_DIR/%.s
ASMS :=

# ── Binarios ──────────────────────────────────────────────────
APP         := $(BUILD)/app
TEST_RUNNER := $(BUILD)/test_runner

# ── Targets ───────────────────────────────────────────────────

all: $(APP) ## Compila el binario principal build/app

test: $(TEST_RUNNER) ## Compila y ejecuta el runner de tests
	@$(TEST_RUNNER)

# TODO: target asm que dependa de $(ASMS)
#   asm: $(ASMS) ## Genera el ensamblador de cada src/*.c en build/asm/

# TODO: enlaza con $(CC) $^ -o $@
$(APP): $(LIB_OBJS) $(APP_OBJS)

# TODO: enlaza con $(CC) $^ -o $@
$(TEST_RUNNER): $(LIB_OBJS) $(TEST_OBJS)

# TODO: regla de patrón para módulos de aplicación y librería
# $(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
#   @mkdir -p $(@D)
#   $(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@

# TODO: segunda regla de patrón .c → .s (lab-03: otra extensión)
# $(ASM_DIR)/%.s: $(SRC_DIR)/%.c
#   @mkdir -p $(@D)
#   $(CC) $(CFLAGS) -I$(INC_DIR) -S $< -o $@

# TODO: static pattern rule para objetos de test
# $(TEST_OBJS): $(TST_DIR)/%.o: $(TEST_DIR)/%.c
#   @mkdir -p $(@D)
#   $(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@

# TODO: carga los .d de headers (semana 04):
#   DEPS := $(patsubst %.o,%.d,$(LIB_OBJS) $(APP_OBJS) $(TEST_OBJS))
#   -include $(DEPS)

# TODO: borra $(BUILD) con la guarda de la semana 03 (dos líneas de receta):
#   $(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
#   @rm -rf -- '$(BUILD)'
clean: ## Elimina el directorio build/
	@echo "[clean] listo"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
