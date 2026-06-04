# ============================================================
# Lab 02 — Cadenas de dependencias
# Semana 01: Tu primer Makefile
# ============================================================
# Pipeline objetivo: prepare → compile → link → run
#
# Instrucciones:
#   1. Ejecuta `make run` ahora y observa qué pasa
#   2. Agrega las dependencias indicadas en los TODO
#   3. Ejecuta `make run` de nuevo — debe imprimir los 4 pasos en orden
# ============================================================

.PHONY: all prepare compile link run clean help

.DEFAULT_GOAL := help

# TODO: agrega 'link' como dependencia  →  run: link
## run: ejecuta el pipeline completo
run:
	@echo "[4/4] Ejecutando programa..."
	@echo ">>> ¡Programa corriendo!"

# TODO: agrega 'compile' como dependencia  →  link: compile
## link: vincula los objetos compilados
link:
	@echo "[3/4] Vinculando objetos..."

# TODO: agrega 'prepare' como dependencia  →  compile: prepare
## compile: compila los fuentes
compile:
	@echo "[2/4] Compilando fuentes..."

## prepare: prepara el entorno de build
prepare:
	@echo "[1/4] Preparando entorno..."

## clean: limpia el estado (sin archivos reales en este lab)
clean:
	@echo "Nada que limpiar en este lab."

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
