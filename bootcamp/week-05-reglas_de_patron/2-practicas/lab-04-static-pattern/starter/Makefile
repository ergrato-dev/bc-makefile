# ============================================================
# Lab 04 — Static pattern rules
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Define LIB_OBJS y APP_OBJS como listas separadas
#   2. Escribe la static pattern rule para LIB_OBJS → build/lib/
#   3. Escribe la static pattern rule para APP_OBJS → build/app/
#   4. Completa el target $(APP) enlazando los dos grupos
#   5. Verifica con: make all && ./build/app
# ============================================================

.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

INC_DIR := include

# ── Listas de fuentes separadas ───────────────────────────────
LIB_SRCS := src/math_ops.c src/string_ops.c
APP_SRCS := src/main.c

# TODO: define LIB_OBJS transformando LIB_SRCS → build/lib/%.o
LIB_OBJS :=

# TODO: define APP_OBJS transformando APP_SRCS → build/main/%.o
APP_OBJS :=

APP := build/calculator

# ── Targets ───────────────────────────────────────────────────

## all: compila y enlaza la aplicación completa
all: $(APP)

$(APP): $(LIB_OBJS) $(APP_OBJS)
	# TODO: enlaza con $(CC) $^ -o $@

# TODO: static pattern rule para LIB_OBJS
# Sintaxis: $(LIB_OBJS): build/lib/%.o: src/%.c
#   - @mkdir -p $(@D)
#   - $(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

# TODO: static pattern rule para APP_OBJS
# Sintaxis: $(APP_OBJS): build/main/%.o: src/%.c
#   - @mkdir -p $(@D)
#   - $(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

## clean: elimina build/
clean:
	@rm -rf build
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
