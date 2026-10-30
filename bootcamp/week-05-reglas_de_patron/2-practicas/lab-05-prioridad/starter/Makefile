# ============================================================
# Lab 05 — Prioridad: regla explícita vs regla de patrón
# Semana 05: Reglas de patrón
# ============================================================
# Instrucciones:
#   1. Observa la regla de patrón %.o: %.c ya definida
#   2. Agrega una regla EXPLÍCITA para debug.o con -g -DDEBUG
#   3. Verifica que make main.o usa el patrón y make debug.o usa la explícita
#   4. Completa 'all' para enlazar main.o, normal.o y debug.o
# ============================================================

.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

OBJS := main.o normal.o debug.o
APP  := app

## all: compila la aplicación
all: $(APP)

$(APP): $(OBJS)
	$(CC) $^ -o $@

# Regla de patrón genérica — aplica a main.o y normal.o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "[patrón] $@ compilado"

# TODO: agrega una regla EXPLÍCITA para debug.o
#       Debe compilar con: $(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
#       Y mostrar: @echo "[debug mode] $@ compilado con -g -DDEBUG"
#       IMPORTANTE: la regla explícita tiene prioridad sobre el patrón

## clean: elimina objetos y binario
clean:
	@rm -f $(OBJS) $(APP)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
