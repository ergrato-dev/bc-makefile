# ============================================================
# Lab 05 — combinadas (SOLUCIÓN)
# Semana 07: Funciones de texto y archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean info count help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build
TARGET := $(BUILD)/pipeline

# src/*.c y un nivel de subdirectorio (src/net/http.c)
SRCS     := $(wildcard src/*.c src/*/*.c)
OBJS     := $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))
OBJ_DIRS := $(sort $(dir $(OBJS)))
INCS     := $(addprefix -I,include)
# formatter parser validator: nombre sin ruta ni extensión, sin main
MODULES  := $(filter-out main,$(notdir $(basename $(SRCS))))

all: $(TARGET) ## Compila el pipeline completo

info: ## Muestra el estado de las variables Make
	@echo "SRCS:     $(SRCS)"
	@echo "OBJS:     $(OBJS)"
	@echo "OBJ_DIRS: $(OBJ_DIRS)"
	@echo "INCS:     $(INCS)"
	@echo "MODULES:  $(MODULES)"

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Compilado: $@"

# Cada objeto necesita que exista su directorio (order-only: no fuerza recompilar)
$(OBJS): | $(OBJ_DIRS)

$(OBJ_DIRS):
	mkdir -p $@

$(BUILD)/%.o: src/%.c
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

count: ## Muestra estadísticas de fuentes
	@echo "Total fuentes: $(words $(SRCS))"

clean: ## Elimina archivos de compilación
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
