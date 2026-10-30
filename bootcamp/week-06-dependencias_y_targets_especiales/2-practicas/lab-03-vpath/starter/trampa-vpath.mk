# ============================================================
# Lab 03 — La trampa: vpath para encontrar TARGETS (paso 6)
# Uso: make -f trampa-vpath.mk
# No lo arregles a base de parches: lee el paso 6 del README.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all limpiar
.DEFAULT_GOAL := all

vpath %.c src src/core src/util
# Error de diseño: usar vpath para que Make "encuentre" los objetos en build/
vpath %.o build

all: app

app: main.o calc.o fmt.o
	@mkdir -p build
	@echo "[link] $^"
	@gcc $^ -o build/app

%.o: %.c
	@mkdir -p build
	@echo "[cc]   $< -> build/$@"
	@gcc -Iinclude -c $< -o build/$@

limpiar:
	rm -f build/main.o build/calc.o build/fmt.o build/app
