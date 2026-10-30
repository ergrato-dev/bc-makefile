# ============================================================
# Lab 02 — Solución: Variable automática $<
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: setup compilar-main compilar-utils compilar-todos enlazar limpiar help

.DEFAULT_GOAL := help

CC := gcc

setup: ## crea los fuentes y headers del lab (src/ e include/)
	@mkdir -p src include
	@echo 'int saludo(void);' > include/utils.h
	@echo 'int suma(int a, int b);' > include/math.h
	@echo '#include <stdio.h>' > src/utils.c
	@echo '#include "utils.h"' >> src/utils.c
	@echo 'int saludo(void) { puts("Hola desde utils"); return 0; }' >> src/utils.c
	@echo '#include "math.h"' > src/math.c
	@echo 'int suma(int a, int b) { return a + b; }' >> src/math.c
	@echo '#include "utils.h"' > src/main.c
	@echo '#include "math.h"' >> src/main.c
	@echo 'int main(void) { return suma(2, 3) == 5 ? saludo() : 1; }' >> src/main.c
	@echo "[setup] Fuentes creados en src/ e include/"

# ── Simulación con echo ───────────────────────────────────────

compilar-main: src/main.c include/utils.h include/math.h ## muestra $< y $^ para main.c y sus headers
	@echo "[cc] Compilando (solo fuente): $<"
	@echo "[cc] Todos los prereqs:        $^"

compilar-utils: src/utils.c include/utils.h ## muestra $< y $^ para utils.c
	@echo "[cc] Compilando (solo fuente): $<"
	@echo "[cc] Todos los prereqs:        $^"

compilar-todos: compilar-main compilar-utils ## ejecuta compilar-main y compilar-utils
	@echo "[resumen] Módulos compilados: $^"

# $< = build/main.o (incorrecto para el linker: "undefined reference")
# $^ = los tres objetos (correcto: el linker los necesita todos)
enlazar: build/main.o build/utils.o build/math.o ## muestra $< y $^ para la lista de objetos
	@echo "[ld] Primer objeto (incorrecto para linker): $<"
	@echo "[ld] TODOS los objetos (correcto):           $^"

# ── Compilación real ──────────────────────────────────────────
# gcc -c compila UN fuente: $<. Los headers son prerrequisitos para que
# Make recompile si cambian, pero no se pasan al compilador.

build/main.o: src/main.c include/utils.h include/math.h
	@mkdir -p build
	$(CC) -Iinclude -c $< -o $@

build/utils.o: src/utils.c include/utils.h
	@mkdir -p build
	$(CC) -Iinclude -c $< -o $@

build/math.o: src/math.c include/math.h
	@mkdir -p build
	$(CC) -Iinclude -c $< -o $@

# El linker necesita TODOS los objetos: $^
build/app: build/main.o build/utils.o build/math.o
	$(CC) $^ -o $@

limpiar: ## borra build/, src/ e include/ generados por setup
	@rm -rf -- build src include
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make setup, luego make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
