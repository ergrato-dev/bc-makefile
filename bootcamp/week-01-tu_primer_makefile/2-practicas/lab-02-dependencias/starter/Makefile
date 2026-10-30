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

.PHONY: prepare compile link run test lint check clean help

.DEFAULT_GOAL := help

# TODO: agrega 'link' como dependencia  →  run: link
run: ## ejecuta el pipeline completo
	@echo "[4/4] Ejecutando programa..."
	@echo ">>> ¡Programa corriendo!"

# TODO: agrega 'compile' como dependencia  →  link: compile
link: ## vincula los objetos compilados
	@echo "[3/4] Vinculando objetos..."

# TODO: agrega 'prepare' como dependencia  →  compile: prepare
compile: ## compila los fuentes
	@echo "[2/4] Compilando fuentes..."

prepare: ## prepara el entorno de build
	@echo "[1/4] Preparando entorno..."

# TODO (paso 7): test y lint dependen los dos de compile  →  test: compile
test: ## ejecuta las pruebas (necesita el código compilado)
	@echo "[test] Pruebas OK."

# TODO (paso 7):  →  lint: compile
lint: ## revisa el estilo (necesita el código compilado)
	@echo "[lint] Estilo OK."

# TODO (paso 7): check depende de test y de lint, en ese orden  →  check: test lint
check: ## pruebas y estilo; compile se ejecuta una sola vez
	@echo "[check] Todo verificado."

clean: ## limpia el estado (sin archivos reales en este lab)
	@echo "Nada que limpiar en este lab."

help: ## muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
