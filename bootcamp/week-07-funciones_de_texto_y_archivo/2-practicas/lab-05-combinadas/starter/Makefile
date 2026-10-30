.PHONY: all clean info help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/pipeline

# TODO: Descubre todos los .c en src/ con $(wildcard)
SRCS :=

# TODO: Genera rutas de objetos: src/%.c → build/%.o
OBJS :=

# TODO: Obtén directorios únicos de los objetos para crearlos antes de compilar
OBJ_DIRS :=

# TODO: Genera el flag -Iinclude con $(addprefix)
INCS :=

all: $(TARGET) ## Compila el pipeline completo

info: ## Muestra el estado de las variables Make
	@echo "SRCS:     $(SRCS)"
	@echo "OBJS:     $(OBJS)"
	@echo "OBJ_DIRS: $(OBJ_DIRS)"
	@echo "INCS:     $(INCS)"

# TODO: Agrega $(OBJS) como prerequisito y completa la receta de enlazado
$(TARGET):
	@echo "Error: completa los TODOs en las variables primero"
	@exit 1

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

clean: ## Elimina archivos de compilación
	rm -rf $(BUILD)

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
