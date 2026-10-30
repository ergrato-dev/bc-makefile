.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

INC_DIR := include

LIB_SRCS := src/math_ops.c src/string_ops.c
APP_SRCS := src/main.c

LIB_OBJS := $(LIB_SRCS:src/%.c=build/lib/%.o)
APP_OBJS := $(APP_SRCS:src/%.c=build/main/%.o)

APP := build/calculator

## all: compila y enlaza la aplicación completa
all: $(APP)

$(APP): $(LIB_OBJS) $(APP_OBJS)
	$(CC) $^ -o $@

$(LIB_OBJS): build/lib/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

$(APP_OBJS): build/main/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

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
