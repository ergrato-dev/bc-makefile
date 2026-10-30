# ============================================================
# Lab 05 — combinadas
# Semana 07: Funciones de texto y archivo
# ============================================================

# TODO: preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all clean info help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/pipeline

# TODO (paso 3): descubre todos los .c en src/ con $(wildcard)
# TODO (paso 10): añade un segundo patrón para un nivel de subdirectorio
SRCS :=

# TODO (paso 4): genera rutas de objetos: src/%.c -> build/%.o
OBJS :=

# TODO (paso 5): directorios únicos de los objetos
OBJ_DIRS :=

# TODO (paso 6): genera el flag -Iinclude con $(addprefix)
INCS :=

# TODO (paso 11): nombres de módulo sin ruta ni extensión, quitando main
MODULES :=

all: $(TARGET) ## Compila el pipeline completo

info: ## Muestra el estado de las variables Make
	@echo "SRCS:     $(SRCS)"
	@echo "OBJS:     $(OBJS)"
	@echo "OBJ_DIRS: $(OBJ_DIRS)"
	@echo "INCS:     $(INCS)"
	@echo "MODULES:  $(MODULES)"

# TODO (paso 7): agrega $(OBJS) como prerrequisito y la receta de enlazado
$(TARGET):
	@echo "Error: completa los TODOs en las variables primero"
	@exit 1

# TODO (paso 10): $(OBJS) depende order-only de $(OBJ_DIRS), y una regla crea cada directorio

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

clean: ## Elimina archivos de compilación
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
