.PHONY: all clean test status help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test

# --------------------------------------------------------------------------
# ANTIPATRÓN (no lo uses): el código de salida del bucle es el del último
# módulo. Si api falla pero frontend pasa, `make test` sale con 0.
#
#   test:
#   	for mod in $(MODULES); do $(MAKE) -C $$mod test; done
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 1: Define MODULE_TARGETS con un nombre por módulo y meta:
#         api/build api/clean api/test worker/build ...
#         Tip: $(foreach g,$(GOALS),$(addsuffix /$(g),$(MODULES)))
#         Decláralos .PHONY: no son archivos.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Una sola regla para todos los MODULE_TARGETS que ejecute
#         $(MAKE) -C <directorio> <meta>
#         Tip: en "api/test", $(@D) es "api" y $(@F) es "test"
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 3: all, clean y test sin receta: solo prerrequisitos
#         Ejemplo: all: $(addsuffix /build,$(MODULES))
# --------------------------------------------------------------------------
all: ## Construir todos los módulos

clean: ## Limpiar artefactos de todos los módulos

test: ## Ejecutar tests en todos los módulos

# --------------------------------------------------------------------------
# TODO 4: 'status' lista cada módulo con ✓ si tiene Makefile y ✗ si no
#         (sin construir nada). Tip: $(wildcard $(m)/Makefile)
# --------------------------------------------------------------------------
status: ## Mostrar estado de todos los módulos
	@echo "TODO: implementa status"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
