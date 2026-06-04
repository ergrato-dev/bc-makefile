.PHONY: all clean test status help
.DEFAULT_GOAL := help

MODULES := api worker frontend

# --------------------------------------------------------------------------
# TODO 1: Implementa el target 'all' que construye cada módulo en MODULES
#         usando $(MAKE) -C <modulo> build
#         Tip: puedes iterar con $(foreach ...) o con un target por módulo
# --------------------------------------------------------------------------
all: ## Construir todos los módulos
	# TODO: iterar sobre $(MODULES) y ejecutar $(MAKE) -C $$mod build

# --------------------------------------------------------------------------
# TODO 2: Implementa 'clean' recursivo para todos los módulos
# --------------------------------------------------------------------------
clean: ## Limpiar artefactos de todos los módulos
	# TODO: iterar y ejecutar $(MAKE) -C $$mod clean

# --------------------------------------------------------------------------
# TODO 3: Implementa 'test' recursivo para todos los módulos
# --------------------------------------------------------------------------
test: ## Ejecutar tests en todos los módulos
	# TODO: iterar y ejecutar $(MAKE) -C $$mod test

# --------------------------------------------------------------------------
# TODO 4: Implementa 'status' que lista los módulos y su estado
#         (sin construir nada, solo informativo)
# --------------------------------------------------------------------------
status: ## Mostrar estado de todos los módulos
	# TODO: @echo "Módulos: $(MODULES)"
	# TODO: imprimir estado de cada uno

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
