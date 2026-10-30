# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all clean test deploy help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test deploy
ENV     ?= development

# --------------------------------------------------------------------------
# NO uses `for mod in $(MODULES); do $(MAKE) -C $$mod ...; done`: el código
# de salida del bucle es el del último módulo y los fallos anteriores se
# pierden. Cada módulo/meta debe ser un target propio.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 1: Define MODULE_TARGETS (api/build api/clean ... frontend/deploy)
#         con $(foreach) y $(addsuffix), y decláralos .PHONY
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Una regla para todos los MODULE_TARGETS que ejecute
#         $(MAKE) -C $(@D) $(@F) ENV=$(ENV)
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 3: all, clean, test y deploy solo con prerrequisitos
#         Ejemplo: all: $(addsuffix /build,$(MODULES))
# --------------------------------------------------------------------------
all: ## Construir todos los módulos

clean: ## Limpiar artefactos de todos los módulos

test: ## Ejecutar tests en todos los módulos

deploy: ## Desplegar todos los módulos (requiere ENV != development)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
