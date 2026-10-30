# ============================================================
# Lab 02 — Cadenas de dependencias (SOLUCIÓN)
# ============================================================

.PHONY: prepare compile link run test lint check clean help

.DEFAULT_GOAL := help

## run: ejecuta el pipeline completo
run: link
	@echo "[4/4] Ejecutando programa..."
	@echo ">>> ¡Programa corriendo!"

## link: vincula los objetos compilados
link: compile
	@echo "[3/4] Vinculando objetos..."

## compile: compila los fuentes
compile: prepare
	@echo "[2/4] Compilando fuentes..."

## prepare: prepara el entorno de build
prepare:
	@echo "[1/4] Preparando entorno..."

## test: ejecuta las pruebas (necesita el código compilado)
test: compile
	@echo "[test] Pruebas OK."

## lint: revisa el estilo (necesita el código compilado)
lint: compile
	@echo "[lint] Estilo OK."

## check: pruebas y estilo; compile se ejecuta una sola vez
check: test lint
	@echo "[check] Todo verificado."

## clean: limpia el estado
clean:
	@echo "Nada que limpiar en este lab."

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
