# ============================================================
# Lab 04 — rutas (SOLUCIÓN)
# Semana 07: Funciones de texto y archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo modules edge help
.DEFAULT_GOAL := help

ARCHIVOS := src/main.c src/utils/io.c include/utils.h build/obj/main.o

DIRECTORIOS   := $(dir $(ARCHIVOS))
NOMBRES       := $(notdir $(ARCHIVOS))
BASES         := $(basename $(ARCHIVOS))
EXTENSIONES   := $(suffix $(ARCHIVOS))
INCLUDE_FLAGS := $(addprefix -I,$(sort $(dir $(ARCHIVOS))))
BACKUPS       := $(addsuffix .bak,$(notdir $(ARCHIVOS)))
STEMS         := $(notdir $(basename $(ARCHIVOS)))

MOD_DIRS := modules/auth/ modules/net/tls/ modules/logger/
# auth tls logger: primero se quita la / final, luego notdir
MODULES  := $(notdir $(patsubst %/,%,$(MOD_DIRS)))

demo: ## Muestra las manipulaciones de ruta
	@echo "Archivos:     $(ARCHIVOS)"
	@echo "Directorios:  $(DIRECTORIOS)"
	@echo "Nombres:      $(NOMBRES)"
	@echo "Bases:        $(BASES)"
	@echo "Extensiones:  $(EXTENSIONES)"
	@echo "-I flags:     $(INCLUDE_FLAGS)"
	@echo "Backups:      $(BACKUPS)"
	@echo "Stems:        $(STEMS)"

modules: ## Muestra los nombres de módulo derivados de MOD_DIRS
	@echo "notdir directo: [$(notdir $(MOD_DIRS))]"
	@echo "Módulos:        $(MODULES)"

edge: ## Casos límite de las funciones de rutas
	@echo "dir sin barra:      $(dir main.c)"
	@echo "basename con punto: $(basename v1.2/app archivo.tar.gz)"
	@echo "suffix doble:       $(suffix archivo.tar.gz)"
	@echo "suffix sin punto:   [$(suffix Makefile)]"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
