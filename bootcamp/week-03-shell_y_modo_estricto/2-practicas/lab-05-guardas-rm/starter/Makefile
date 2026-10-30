# ============================================================
# Lab 05 — Guardas para rm -rf, make -n y el prefijo +
# Semana 03: Shell en recetas y modo estricto
# ============================================================
# Todo lo que se borra en este lab está dentro de la carpeta del lab.
# No ejecutes nunca un clean con BUILD_DIR=/ sin -n: usa los pasos del README.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: prepare simulate-clean clean reset help
.DEFAULT_GOAL := help

BUILD_DIR := build

prepare: ## Crea build/, "mi build/" y mi/notas.txt
	mkdir -p $(BUILD_DIR) 'mi build' mi
	echo "artefacto" > $(BUILD_DIR)/app.txt
	echo "no borrar" > mi/notas.txt

# Solo imprime: así es el clean "clásico" que circula por internet.
simulate-clean: ## Muestra qué ejecutaría un clean sin guarda (no borra nada)
	@echo "[simulado] rm -rf $(BUILD_DIR)/*"

# TODO (paso 3): comillas simples alrededor de la ruta y -- antes de ella.
# TODO (paso 4): guarda contra BUILD_DIR vacía, en la primera línea.
# TODO (paso 6): guarda contra BUILD_DIR fuera del proyecto, en la segunda.
clean: ## Borra BUILD_DIR
	rm -rf $(BUILD_DIR)

# El prefijo + hace que la línea se ejecute incluso con make -n.
# Existe para las llamadas a $(MAKE) (Semana 10). Aquí está mal puesto a
# propósito: es lo que estudias en el paso 7. No lo copies.
reset: ## Borra BUILD_DIR (con un + mal puesto)
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	+rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
