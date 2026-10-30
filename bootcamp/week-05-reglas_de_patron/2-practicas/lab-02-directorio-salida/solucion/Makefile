.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

SRC_DIR   := src
BUILD_DIR := build
INC_DIR   := include

SRCS := $(SRC_DIR)/main.c $(SRC_DIR)/utils.c
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
APP  := $(BUILD_DIR)/app

## all: compila la aplicación completa
all: $(APP)

$(APP): $(OBJS)
	$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

## clean: elimina el directorio build/
clean:
	@rm -rf $(BUILD_DIR)

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
