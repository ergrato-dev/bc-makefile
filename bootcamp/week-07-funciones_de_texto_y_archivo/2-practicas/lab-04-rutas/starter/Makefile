# ============================================================
# Lab 04 — rutas
# Semana 07: Funciones de texto y archivo
# ============================================================

# TODO: preámbulo estricto de la semana 03
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: demo modules edge help
.DEFAULT_GOAL := help

ARCHIVOS := src/main.c src/utils/io.c include/utils.h build/obj/main.o

# TODO: Extrae la parte directorio de cada archivo (con / final)
DIRECTORIOS :=

# TODO: Extrae solo el nombre sin directorio
NOMBRES :=

# TODO: Extrae la ruta sin extensión
BASES :=

# TODO: Extrae solo la extensión
EXTENSIONES :=

# TODO: Genera flags -I para cada directorio único
# Tip: $(addprefix -I,$(sort $(dir $(ARCHIVOS))))
INCLUDE_FLAGS :=

# TODO: Agrega .bak como sufijo a cada nombre de archivo (sin directorio)
# Tip: primero $(notdir ...), luego $(addsuffix ...)
BACKUPS :=

MOD_DIRS := modules/auth/ modules/net/tls/ modules/logger/
# TODO (paso 10): nombres de módulo sin barra ni directorio: auth tls logger
MODULES :=

demo: ## Muestra las manipulaciones de ruta
	@echo "Archivos:     $(ARCHIVOS)"
	@echo "Directorios:  $(DIRECTORIOS)"
	@echo "Nombres:      $(NOMBRES)"
	@echo "Bases:        $(BASES)"
	@echo "Extensiones:  $(EXTENSIONES)"
	@echo "-I flags:     $(INCLUDE_FLAGS)"
	@echo "Backups:      $(BACKUPS)"

modules: ## Muestra los nombres de módulo derivados de MOD_DIRS
	@echo "notdir directo: [$(notdir $(MOD_DIRS))]"
	@echo "Módulos:        $(MODULES)"

edge: ## Casos límite de las funciones de rutas
	@echo "edge no implementado (paso 11)"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
