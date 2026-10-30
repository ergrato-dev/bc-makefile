# ============================================================
# Lab 03 — filter
# Semana 07: Funciones de texto y archivo
# ============================================================

# TODO: preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: demo pick help
.DEFAULT_GOAL := help

ALL_FILES := src/main.c src/utils.c include/utils.h include/types.h \
             build/main.o build/utils.o docs/README.md docs/API.md

# TODO (paso 3): conserva solo archivos .c
C_SRCS :=

# TODO (paso 4): conserva solo archivos .h
HEADERS :=

# TODO (paso 5): conserva solo archivos .o
OBJECTS :=

# TODO (paso 6): elimina todo lo que esté en docs/ usando filter-out con patrón docs/%
NO_DOCS :=

# TODO (paso 7): conserva solo archivos en src/ e include/ con dos patrones en un $(filter)
SRC_AND_INC :=

# Directorios de primer nivel, sin repetir: build docs include src
DIRS := $(sort $(patsubst %/,%,$(dir $(ALL_FILES))))
# Directorio pedido en 'make pick DIR=...'
DIR ?=

demo: ## Muestra el resultado de los filtros
	@echo "Todos:      $(ALL_FILES)"
	@echo ".c:         $(C_SRCS)"
	@echo ".h:         $(HEADERS)"
	@echo ".o:         $(OBJECTS)"
	@echo "Sin docs:   $(NO_DOCS)"
	@echo "src+inc:    $(SRC_AND_INC)"

# TODO (paso 9): imprime solo los archivos de $(DIR) con un patrón construido con la variable
# TODO (paso 10): primera línea de la receta = guarda con filter + error si DIR no está en DIRS
pick: ## Lista los archivos de un directorio (DIR=include)
	@echo "pick no implementado"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
