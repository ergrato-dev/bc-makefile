.PHONY: all build clean list-sources help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/programa

# TODO: Reemplaza esta lista hardcodeada con $(wildcard src/*.c)
SRCS := src/main.c src/calc.c src/io.c

# TODO: Reemplaza esta lista hardcodeada con $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))
OBJS := $(BUILD)/main.o $(BUILD)/calc.o $(BUILD)/io.o

all: build ## Alias para build

list-sources: ## Muestra las fuentes y objetos detectados
	@echo "SRCS  = $(SRCS)"
	@echo "OBJS  = $(OBJS)"
	@echo "Total = $(words $(SRCS)) archivos"

build: $(TARGET) ## Compila el programa

$(TARGET): $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Compilado: $@"

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina archivos de compilación
	rm -rf $(BUILD)

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
