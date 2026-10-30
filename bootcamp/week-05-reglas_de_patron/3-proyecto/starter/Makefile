# ============================================================
# Proyecto — Compilador genérico para proyectos C
# Semana 05: Reglas de patrón
# ============================================================
# Entregables:
#   - build/app: binario principal
#   - build/test_runner: binario de tests
# Targets requeridos: all, test, clean, help
# ============================================================

# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all test clean help

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

# ── Fuentes ───────────────────────────────────────────────────
# TODO: usa $(wildcard ...) para encontrar todos los .c en SRC_DIR
SRCS :=

# TODO: excluye main.c de los módulos de librería y define LIB_SRCS
LIB_SRCS :=

# TODO: define APP_SRCS solo con src/main.c
APP_SRCS :=

# TODO: define TEST_SRCS con todos los .c en TEST_DIR
TEST_SRCS :=

# ── Objetos ───────────────────────────────────────────────────
# TODO: define LIB_OBJS transformando LIB_SRCS → OBJ_DIR/%.o
LIB_OBJS :=

# TODO: define APP_OBJS transformando APP_SRCS → OBJ_DIR/%.o
APP_OBJS :=

# TODO: define TEST_OBJS transformando TEST_SRCS → TST_DIR/%.o
TEST_OBJS :=

# ── Binarios ──────────────────────────────────────────────────
APP         := $(BUILD)/app
TEST_RUNNER := $(BUILD)/test_runner

# ── Targets ───────────────────────────────────────────────────

## all: compila el binario principal
all: $(APP)

$(APP): $(LIB_OBJS) $(APP_OBJS)
	# TODO: enlaza con $(CC) $^ -o $@

## test: compila y ejecuta el runner de tests
test: $(TEST_RUNNER)
	@$(TEST_RUNNER)

$(TEST_RUNNER): $(LIB_OBJS) $(TEST_OBJS)
	# TODO: enlaza con $(CC) $^ -o $@

# TODO: regla de patrón para módulos de aplicación y librería
# $(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
#   @mkdir -p $(@D)
#   $(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@

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
## clean: elimina el directorio build/
clean:
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
