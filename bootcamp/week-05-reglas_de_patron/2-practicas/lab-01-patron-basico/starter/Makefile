# ============================================================
# Lab 01 — Regla de patrón %.o: %.c
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Define OBJS derivando la lista de .c a .o
#   2. Escribe la regla de patrón %.o: %.c con variables automáticas
#   3. Completa el target 'app' para enlazar todos los objetos
#   4. Verifica con: make app && ./app
# ============================================================

.PHONY: all clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC     := gcc
CFLAGS := -Wall -std=c11

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := main.c math.c greet.c
# TODO: define OBJS transformando cada .c en .o
#       Pista: $(SRCS:.c=.o)
OBJS :=

APP := app

# ── Targets ───────────────────────────────────────────────────

## all: compila la aplicación completa
all: $(APP)

## app: enlaza todos los objetos en el binario
$(APP): $(OBJS)
	# TODO: enlaza $^ y genera $@ con $(CC)

# TODO: escribe la regla de patrón %.o: %.c
#       Receta: compila $< y escribe en $@ con $(CC) $(CFLAGS)

## clean: elimina objetos y binario
clean:
	@rm -f $(OBJS) $(APP)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
