# ============================================================
# Lab 06 — funciones rotas (SOLUCIÓN)
# Semana 07: Funciones de texto y archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo help
.DEFAULT_GOAL := help

SRCS     := src/main.c src/parser.c src/utils.c
INC_DIRS := include

# FIX 1: stem correcto captura el directorio src/
OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))

# FIX 2: % antes de .c para que coincida con cualquier archivo .c
C_SRCS := $(filter %.c,$(SRCS))

# FIX 3: % para coincidir con cualquier palabra que contenga utils.c
NO_UTILS := $(filter-out %utils.c,$(SRCS))

# FIX 4: addprefix sobre INC_DIRS, no sobre las fuentes
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# FIX 5: sin espacios tras las comas; y patsubst, que solo toca el final .c
DEPS := $(patsubst %.c,%.d,$(SRCS))

# FIX 6: el comentario va en su propia línea; strip protege de valores externos
# directorio de salida
OUT_DIR := out
BIN     := $(strip $(OUT_DIR))/app

demo: ## Muestra las transformaciones corregidas
	@echo "OBJS:      $(OBJS)"
	@echo "C_SRCS:    $(C_SRCS)"
	@echo "NO_UTILS:  $(NO_UTILS)"
	@echo "INC_FLAGS: $(INC_FLAGS)"
	@echo "DEPS:      $(DEPS) ($(words $(DEPS)) palabras)"
	@echo "BIN:       [$(BIN)]"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
