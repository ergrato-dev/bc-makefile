# ============================================================
# Lab 02 — Cadenas de dependencias (SOLUCIÓN)
# ============================================================

.PHONY: prepare compile link run test lint check clean help

.DEFAULT_GOAL := help

run: link ## ejecuta el pipeline completo
	@echo "[4/4] Ejecutando programa..."
	@echo ">>> ¡Programa corriendo!"

link: compile ## vincula los objetos compilados
	@echo "[3/4] Vinculando objetos..."

compile: prepare ## compila los fuentes
	@echo "[2/4] Compilando fuentes..."

prepare: ## prepara el entorno de build
	@echo "[1/4] Preparando entorno..."

test: compile ## ejecuta las pruebas (necesita el código compilado)
	@echo "[test] Pruebas OK."

lint: compile ## revisa el estilo (necesita el código compilado)
	@echo "[lint] Estilo OK."

check: test lint ## pruebas y estilo; compile se ejecuta una sola vez
	@echo "[check] Todo verificado."

clean: ## limpia el estado
	@echo "Nada que limpiar en este lab."

help: ## muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
