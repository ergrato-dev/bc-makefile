# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

# --------------------------------------------------------------------------
# TODO 0: Guarda de versión mínima (lab-05, paso 2). Define
#         MIN_MAKE_VERSION := 4.3 y, con ifneq + $(firstword $(sort ...)),
#         detén Make con $(error ...) si MAKE_VERSION es menor. El mensaje
#         debe contener "requiere GNU Make" y decir qué versión se usa.
#         Pruébala con: make help MAKE_VERSION=3.81
# --------------------------------------------------------------------------

.PHONY: all clean test deploy doctor help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test deploy validate
ENV     ?= development

# --------------------------------------------------------------------------
# NO uses `for mod in $(MODULES); do $(MAKE) -C $$mod ...; done`: el código
# de salida del bucle es el del último módulo y los fallos anteriores se
# pierden. Cada módulo/meta debe ser un target propio.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 1: Define MODULE_TARGETS (api/build api/clean ... frontend/validate)
#         con $(foreach) y $(addsuffix), y decláralos .PHONY
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Una regla para todos los MODULE_TARGETS que ejecute
#         $(MAKE) --no-print-directory -C $(@D) $(@F) ENV=$(ENV)
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 3: all, clean, test y deploy solo con prerrequisitos
#         Ejemplo: all: $(addsuffix /build,$(MODULES))
# --------------------------------------------------------------------------
all: ## Construir todos los módulos

clean: ## Limpiar artefactos de todos los módulos

test: ## Ejecutar tests en todos los módulos

deploy: ## Desplegar todos los módulos

# --------------------------------------------------------------------------
# TODO 4: 'doctor' depende de <módulo>/validate de los tres módulos y su
#         receta muestra con $(info ...) una línea por dato:
#           MAKE_VERSION  = <versión> (mínimo <MIN_MAKE_VERSION>)
#           MAKECMDGOALS, MODULES y ENV
#         y termina con @echo "Diagnóstico OK"
# --------------------------------------------------------------------------
doctor: ## Diagnosticar Make y validar cada módulo

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
