# ============================================================
# Lab 03 — La trampa: vpath para encontrar TARGETS (paso 6)
# Uso: make -f trampa-vpath.mk
# No lo arregles a base de parches: lee el paso 6 del README.
# ============================================================

# FIX: tres síntomas, una causa: vpath sirve para encontrar prerrequisitos que
#   ya existen, no para decidir dónde se crean los targets.
#   1. Primera ejecución: los .o no existen, vpath no los encuentra, así que $@
#      y $^ valen "main.o" (sin build/). La receta escribe build/main.o, pero el
#      linker recibe main.o y falla.
#   2. Segunda: ahora vpath sí encuentra build/*.o y $^ trae las rutas: enlaza.
#   3. Tras tocar calc.c: un target hallado por vpath que hay que rehacer se
#      rehace en el directorio actual. $^ mezcla build/main.o con calc.o y falla.
#   Diseño correcto (el de Makefile): targets con ruta, build/%.o: %.c, y
#   vpath solo para los fuentes.

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
