# ============================================================
# Proyecto Semana 06 — Build C con dependencias de headers exactas
# ============================================================
# Objetivo: que `make all` haga exactamente el trabajo necesario.
#   - Tocar un header recompila solo a quien lo incluye (-MMD -MP)
#   - Crear cosas en build/ no recompila nada (order-only)
#   - El generador corre una vez aunque uses -j (grouped target &:)
#   - Cambiar flags recompila todo (stamp de flags)
# Formato de salida obligatorio (lo cuenta el autograding):
#   [gen]  ...   lo imprime tools/gen-version.sh
#   [cc]   <fuente>
#   [link] <binario>
# ============================================================

# TODO 1: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:
# TODO 2: activa la segunda expansión para poder usar $$(@D) en prerrequisitos

.PHONY: all clean help FORCE
.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
# TODO 3: DEPFLAGS con las dos flags que generan un .d completo por objeto

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
GEN_DIR   := $(BUILD_DIR)/gen
APP       := $(BUILD_DIR)/app
# Preprocesador: dónde buscar headers (los escritos a mano y los generados)
CPPFLAGS  := -Iinclude -I$(GEN_DIR)

# ── Código generado ──────────────────────────────────────────
# tools/gen-version.sh VERSION build/gen  →  escribe version.c Y version.h
GEN_TOOL := tools/gen-version.sh
GEN_C    := $(GEN_DIR)/version.c
GEN_H    := $(GEN_DIR)/version.h

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o) $(GEN_C:.c=.o)
# TODO 4: DEPS, un .d por cada objeto de OBJS

FLAGS_STAMP := $(BUILD_DIR)/compile-flags.txt
COMPILE_CMD := $(CC) $(CPPFLAGS) $(CFLAGS)

all: $(APP) ## Compila build/app de forma incremental

# ── Enlace ────────────────────────────────────────────────────
$(APP): $(OBJS)
	@$(CC) $^ -o $@
	@echo "[link] $@"

# ── Compilación ───────────────────────────────────────────────
# TODO 5: regla de patrón $(BUILD_DIR)/%.o desde $(SRC_DIR)/%.c
#   - prerrequisitos normales: el fuente y $(FLAGS_STAMP)
#   - order-only: el directorio del objeto, $$(@D)/
#   - receta: $(COMPILE_CMD) $(DEPFLAGS) -c $< -o $@ y luego
#     @echo "[cc]   $<"
# TODO 6: la misma regla para $(GEN_DIR)/%.o desde $(GEN_DIR)/%.c

# TODO 7: el header generado debe existir antes de compilar cualquier objeto,
#   pero tocarlo NO debe recompilarlos todos. ¿Normal u order-only?

# ── Generador ─────────────────────────────────────────────────
# TODO 8: una sola regla con $(GEN_C) y $(GEN_H) como targets, que dependa de
#   $(GEN_TOOL) y VERSION (y order-only de $(GEN_DIR)/). Receta:
#   @bash $(GEN_TOOL) VERSION $(GEN_DIR)
#   Pruébala con: make clean && make -j8 all | grep -c '^.gen.'  → 1

# ── Stamp de flags ────────────────────────────────────────────
# TODO 9: $(FLAGS_STAMP) depende de FORCE (y order-only de su directorio).
#   La receta reescribe el archivo SOLO si '$(COMPILE_CMD)' cambió (usa cmp -s).

# TODO 10: regla de patrón %/ que crea cualquier directorio con mkdir -p,
#   y márcala con .PRECIOUS: %/ para que Make no intente borrar los
#   directorios como archivos intermedios (lab-05)

# TODO 11: incluye los .d sin fallar cuando todavía no existen

# TODO 12: en 'clean', guarda + borrado seguro (semana 03). Receta:
#   $(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
#   @rm -rf -- '$(BUILD_DIR)'
clean: ## Elimina build/ completo
	@echo "[clean] listo"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
