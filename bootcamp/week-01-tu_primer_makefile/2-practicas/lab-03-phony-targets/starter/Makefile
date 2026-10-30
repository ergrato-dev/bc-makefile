# ============================================================
# Lab 03 — .PHONY: targets que no crean archivos
# Semana 01: Tu primer Makefile
# ============================================================
# EXPERIMENTO:
#   1. Ejecuta `make build` — crea output/app.txt
#   2. Ejecuta `touch clean` — crea un archivo llamado 'clean'
#   3. Ejecuta `make clean` — observa qué pasa sin .PHONY
#   4. Agrega el TODO de abajo y ejecuta `make clean` de nuevo
# ============================================================

# TODO: declara .PHONY con los cuatro targets: all build clean help

.DEFAULT_GOAL := help

all: build ## construye todo
	@echo "Todo listo."

build: ## crea output/app.txt
	@echo "Construyendo..."
	@mkdir -p output
	@echo "contenido de la app" > output/app.txt
	@echo "Build completo: output/app.txt creado"

clean: ## elimina directorio output
	@echo "Limpiando output/..."
	@rm -rf output
	@echo "Limpio."

help: ## muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
