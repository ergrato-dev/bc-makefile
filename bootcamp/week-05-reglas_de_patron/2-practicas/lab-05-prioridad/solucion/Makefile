SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

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

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "[patrón] $@ compilado"

debug.o: debug.c
	$(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
	@echo "[debug mode] $@ compilado con -g -DDEBUG"

## clean: elimina objetos y binario
clean:
	@rm -f $(OBJS) $(APP)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
