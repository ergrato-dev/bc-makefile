# ============================================================
# Lab 02 — patsubst (SOLUCIÓN)
# Semana 07: Funciones de texto y archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo trampas help
.DEFAULT_GOAL := help

SRCS         := src/main.c src/utils.c src/network.c src/config.c
OBJS         := $(patsubst src/%.c,build/%.o,$(SRCS))
TEST_BINS    := $(patsubst build/%.o,bin/%,$(OBJS))
RELEASE_SRCS := $(subst src,release,$(SRCS))
# Referencia de sustitución: atajo de patsubst sobre una variable
OBJS_REF     := $(SRCS:src/%.c=build/%.o)
DEPS         := $(patsubst src/%.c,deps/%.d,$(SRCS))

# Trampas: un nombre que contiene "src" y una lista con palabras que no casan
TRAMPA       := src/srcmap.c
MIXTA        := main.c README.md utils.c

demo: ## Muestra las transformaciones con patsubst y subst
	@echo "SRCS:         $(SRCS)"
	@echo "OBJS:         $(OBJS)"
	@echo "TEST_BINS:    $(TEST_BINS)"
	@echo "RELEASE_SRCS: $(RELEASE_SRCS)"
	@echo "OBJS_REF:     $(OBJS_REF)"
	@echo "DEPS:         $(DEPS)"

trampas: ## Compara subst y patsubst en casos límite
	@echo "subst:        $(subst src,release,$(TRAMPA))"
	@echo "patsubst:     $(patsubst src/%,release/%,$(TRAMPA))"
	@echo "sin casar:    $(patsubst %.c,%.o,$(MIXTA))"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
