.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

SRCS := main.c math.c greet.c
OBJS := $(SRCS:.c=.o)
APP  := app

## all: compila la aplicación completa
all: $(APP)

## app: enlaza todos los objetos en el binario
$(APP): $(OBJS)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

## clean: elimina objetos y binario
clean:
	@rm -f $(OBJS) $(APP)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
