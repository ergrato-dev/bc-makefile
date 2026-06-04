.PHONY: all clean info count help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/pipeline

SRCS     := $(wildcard src/*.c)
OBJS     := $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))
OBJ_DIRS := $(sort $(dir $(OBJS)))
INCS     := $(addprefix -I,include)

all: $(TARGET) ## Compila el pipeline completo

info: ## Muestra el estado de las variables Make
	@echo "SRCS:     $(SRCS)"
	@echo "OBJS:     $(OBJS)"
	@echo "OBJ_DIRS: $(OBJ_DIRS)"
	@echo "INCS:     $(INCS)"

$(TARGET): $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Compilado: $@"

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

count: ## Muestra estadísticas de fuentes
	@echo "Total fuentes: $(words $(SRCS))"

clean: ## Elimina archivos de compilación
	rm -rf $(BUILD)

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
