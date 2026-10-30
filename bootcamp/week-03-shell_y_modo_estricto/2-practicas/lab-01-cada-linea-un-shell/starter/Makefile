# ============================================================
# Lab 01 — Cada línea, un shell nuevo
# Semana 03: Shell en recetas y modo estricto
# ============================================================
# Varias recetas de este archivo "parecen" correctas y no lo son.
# Sigue el README paso a paso: primero ejecuta, observa, y luego arregla.
# ============================================================

.PHONY: prepare where package greet home count clean help
.DEFAULT_GOAL := help

BUILD_DIR := build

prepare: ## Crea build/ con dos reportes de ejemplo
	mkdir -p $(BUILD_DIR)
	echo "enero" > $(BUILD_DIR)/enero.txt
	echo "febrero" > $(BUILD_DIR)/febrero.txt

# TODO (paso 2): pwd y ls muestran el directorio del lab, no build/.
where: ## Muestra dónde está y qué hay en build/
	cd $(BUILD_DIR)
	pwd
	ls

# TODO (paso 3): tar no encuentra los .txt. Haz que el cd y el tar compartan shell.
package: prepare ## Empaqueta los .txt de build/ en build/reportes.tar.gz
	cd $(BUILD_DIR)
	tar -czf reportes.tar.gz enero.txt febrero.txt

# TODO (paso 4): imprime "hola, " sin el nombre.
greet: ## Saluda usando una variable de shell
	DESTINO=mundo
	echo "hola, $$DESTINO"

# TODO (paso 5): imprime "Tu HOME es OME".
home: ## Muestra tu directorio HOME
	echo "Tu HOME es $HOME"

# TODO (paso 6): recorre build/*.txt con un for de shell y, por cada archivo,
# imprime "build/enero.txt -> enero" (nombre -> contenido).
# Escríbelo en varias líneas de Makefile unidas con \ al final de cada una.
count: prepare ## Lista cada reporte con su contenido
	@echo "TODO: implementa el bucle del paso 6"

# La guarda de rm -rf la estudiarás en el lab-05; de momento, cópiala tal cual.
clean: ## Borra build/ y el tar que el paso 3 dejó fuera de sitio
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
	rm -f reportes.tar.gz

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
