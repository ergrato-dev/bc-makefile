.PHONY: all test clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11

SRC_DIR  := src
INC_DIR  := include
TEST_DIR := tests
BUILD    := build
OBJ_DIR  := $(BUILD)/obj
TST_DIR  := $(BUILD)/test

SRCS     := $(wildcard $(SRC_DIR)/*.c)
LIB_SRCS := $(filter-out $(SRC_DIR)/main.c, $(SRCS))
APP_SRCS := $(SRC_DIR)/main.c
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)

LIB_OBJS  := $(LIB_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
APP_OBJS  := $(APP_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TEST_OBJS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(TST_DIR)/%.o)

APP         := $(BUILD)/app
TEST_RUNNER := $(BUILD)/test_runner

## all: compila el binario principal
all: $(APP)

$(APP): $(LIB_OBJS) $(APP_OBJS)
	$(CC) $^ -o $@

## test: compila y ejecuta el runner de tests
test: $(TEST_RUNNER)
	@$(TEST_RUNNER)

$(TEST_RUNNER): $(LIB_OBJS) $(TEST_OBJS)
	$(CC) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

$(TEST_OBJS): $(TST_DIR)/%.o: $(TEST_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

## clean: elimina el directorio build/
clean:
	@rm -rf $(BUILD)
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
