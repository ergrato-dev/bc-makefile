# ============================================================
# Lab 02 — patsubst
# Semana 07: Funciones de texto y archivo
# ============================================================

# TODO: preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: demo trampas help
.DEFAULT_GOAL := help

# Lista de fuentes de ejemplo (no necesitas crear estos archivos)
SRCS := src/main.c src/utils.c src/network.c src/config.c

# TODO (paso 3): $(patsubst src/%.c,build/%.o,$(SRCS))
OBJS :=

# TODO (paso 4): $(patsubst build/%.o,bin/%,$(OBJS))
TEST_BINS :=

# TODO (paso 5): $(subst src,release,$(SRCS))
RELEASE_SRCS :=

# TODO (paso 7): la misma transformación que OBJS con una referencia de sustitución
OBJS_REF :=

# Casos límite para el paso 8 (no los cambies)
TRAMPA := src/srcmap.c
MIXTA  := main.c README.md utils.c

demo: ## Muestra las transformaciones con patsubst y subst
	@echo "SRCS:         $(SRCS)"
	@echo "OBJS:         $(OBJS)"
	@echo "TEST_BINS:    $(TEST_BINS)"
	@echo "RELEASE_SRCS: $(RELEASE_SRCS)"
	@echo "OBJS_REF:     $(OBJS_REF)"

# TODO (paso 8): tres líneas: subst y patsubst sobre TRAMPA, patsubst %.c,%.o sobre MIXTA
trampas: ## Compara subst y patsubst en casos límite
	@echo "trampas no implementado"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
