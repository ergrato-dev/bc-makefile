# ============================================================
# Lab 01 — Cada línea, un shell nuevo (SOLUCIÓN)
# Semana 03: Shell en recetas y modo estricto
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: prepare where package greet home count clean help
.DEFAULT_GOAL := help

BUILD_DIR := build

prepare: ## Crea build/ con dos reportes de ejemplo
	mkdir -p $(BUILD_DIR)
	echo "enero" > $(BUILD_DIR)/enero.txt
	echo "febrero" > $(BUILD_DIR)/febrero.txt

# Cada línea de receta es un proceso de shell distinto: el cd muere con su
# línea. && encadena en el mismo shell y además para si el cd falla.
where: ## Muestra dónde está y qué hay en build/
	cd $(BUILD_DIR) && pwd && ls

package: prepare ## Empaqueta los .txt de build/ en build/reportes.tar.gz
	cd $(BUILD_DIR) && tar -czf reportes.tar.gz enero.txt febrero.txt

# La variable de shell solo vive en el shell que la creó: misma línea.
greet: ## Saluda usando una variable de shell
	DESTINO=mundo; echo "hola, $$DESTINO"

# $HOME lo expande Make como $(H) + "OME". $$ le llega al shell como $.
home: ## Muestra tu directorio HOME
	echo "Tu HOME es $$HOME"

# Con \ al final, Make une las líneas y se las pasa a un solo shell.
# Por eso cada comando del cuerpo termina en ; antes de la barra.
count: prepare ## Lista cada reporte con su contenido
	@for f in $(BUILD_DIR)/*.txt; do \
		echo "$$f -> $$(cat "$$f")"; \
	done

clean: ## Borra build/ y el tar que el paso 3 dejó fuera de sitio
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
	rm -f reportes.tar.gz

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
