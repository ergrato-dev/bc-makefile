# ============================================================
# Proyecto Semana 05 — Solución: compilador genérico para proyectos C
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# Sin reglas implícitas de serie: si tu patrón no casa, el error es
# "No rule to make target", no una compilación escondida con otras flags.
MAKEFLAGS += -r

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
SRCS      := $(wildcard $(SRC_DIR)/*.c)
LIB_SRCS  := $(filter-out $(SRC_DIR)/main.c, $(SRCS))
APP_SRCS  := $(SRC_DIR)/main.c
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)

# ── Objetos y derivados ───────────────────────────────────────
LIB_OBJS  := $(LIB_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
APP_OBJS  := $(APP_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TEST_OBJS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(TST_DIR)/%.o)
ASMS      := $(SRCS:$(SRC_DIR)/%.c=$(ASM_DIR)/%.s)
# .d de headers generados por -MMD -MP (semana 04)
DEPS      := $(patsubst %.o,%.d,$(LIB_OBJS) $(APP_OBJS) $(TEST_OBJS))

# ── Binarios ──────────────────────────────────────────────────
APP         := $(BUILD)/app
TEST_RUNNER := $(BUILD)/test_runner

# ── Targets ───────────────────────────────────────────────────

all: $(APP) ## Compila el binario principal build/app

test: $(TEST_RUNNER) ## Compila y ejecuta el runner de tests
	@$(TEST_RUNNER)

asm: $(ASMS) ## Genera el ensamblador de cada src/*.c en build/asm/

# ── Reglas explícitas: solo los binarios ──────────────────────
$(APP): $(LIB_OBJS) $(APP_OBJS)
	$(CC) $^ -o $@

$(TEST_RUNNER): $(LIB_OBJS) $(TEST_OBJS)
	$(CC) $^ -o $@

# ── Reglas de patrón ──────────────────────────────────────────
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@

# Segunda regla de patrón, otra extensión: .c → .s
$(ASM_DIR)/%.s: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -S $< -o $@

# ── Static pattern rule: solo los objetos de test ─────────────
$(TEST_OBJS): $(TST_DIR)/%.o: $(TEST_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@

-include $(DEPS)

# ── Utilidades ────────────────────────────────────────────────
clean: ## Elimina el directorio build/
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "[clean] listo"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
