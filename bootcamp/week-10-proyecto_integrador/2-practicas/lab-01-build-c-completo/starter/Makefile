.PHONY: all clean info help
.DEFAULT_GOAL := help

# --- Compilador y flags ---
CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11 -Iinclude
LDFLAGS :=

# --- Directorios ---
SRC_DIR   := src
BUILD_DIR := build

# --- Fuentes y objetos ---
# TODO: usar $(wildcard ...) para encontrar todos los .c en SRC_DIR
SRCS :=

# TODO: usar $(patsubst ...) para calcular los .o en BUILD_DIR a partir de SRCS
OBJS :=

# TODO: los archivos .d de dependencias de headers tienen la misma ruta que .o pero extensión .d
DEPS :=

# TODO: incluir los archivos .d con -include para que Make conozca dependencias de headers
# Pista: -include $(DEPS)  (el guión evita error si no existen todavía)

# --- Ejecutable ---
TARGET := $(BUILD_DIR)/app

# -------------------------------------------------------

all: $(TARGET) ## Compilar el proyecto completo

$(TARGET): $(OBJS) | $(BUILD_DIR)
	@echo "Enlazando $@ ..."
	$(CC) $(LDFLAGS) -o $@ $^

# TODO: pattern rule para compilar %.c → $(BUILD_DIR)/%.o
# Debe:
#   - crear el directorio destino si no existe (| $(BUILD_DIR) no basta para subdirectorios)
#   - usar -MMD -MP para generar .d automáticamente
#   - usar $< para la fuente y $@ para el objeto
#   - imprimir: Compilando $< ...
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	# TODO: implementar

$(BUILD_DIR):
	mkdir -p $@

clean: ## Eliminar artefactos de build
	rm -rf $(BUILD_DIR)

info: ## Mostrar fuentes y objetos calculados
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "DEPS = $(DEPS)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
