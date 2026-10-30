# ============================================================
# Lab 05 — Guardas para rm -rf, make -n y el prefijo + (SOLUCIÓN)
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

# Las guardas son funciones de Make: se expanden antes de lanzar ningún shell,
# también con make -n. $(error) detiene Make con el mensaje indicado.
#   1. BUILD_DIR vacía: un typo ($(BUIDL_DIR)) o un ?= con entorno vacío.
#   2. BUILD_DIR fuera del proyecto: su ruta absoluta tiene que empezar por
#      $(CURDIR)/. Descarta /, ., .., ../.. y $(HOME).
# Comillas: una ruta con espacios es UN argumento. --: una ruta que empiece
# por - no se interpreta como opción de rm.
clean: ## Borra BUILD_DIR
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(filter $(CURDIR)/%,$(abspath $(BUILD_DIR))),,$(error BUILD_DIR='$(BUILD_DIR)' está fuera del proyecto: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

# Sin +: con make -n, un comando destructivo solo se imprime.
# + es para las llamadas a $(MAKE) (Semana 10), nunca para rm.
reset: clean ## Borra BUILD_DIR (igual que clean)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
