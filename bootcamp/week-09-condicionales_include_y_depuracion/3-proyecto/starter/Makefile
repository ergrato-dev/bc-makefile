.PHONY: all clean test deploy help
.DEFAULT_GOAL := help

MODULES := api worker frontend
ENV     ?= development

# --------------------------------------------------------------------------
# TODO 1: Implementa 'all' para construir todos los módulos con $(MAKE) -C
# --------------------------------------------------------------------------
all: ## Construir todos los módulos
	# TODO: for mod in $(MODULES); do $(MAKE) -C $$mod build; done

# --------------------------------------------------------------------------
# TODO 2: Implementa 'clean' recursivo
# --------------------------------------------------------------------------
clean: ## Limpiar artefactos de todos los módulos
	# TODO: for mod in $(MODULES); do $(MAKE) -C $$mod clean; done

# --------------------------------------------------------------------------
# TODO 3: Implementa 'test' recursivo pasando ENV a cada submake
# --------------------------------------------------------------------------
test: ## Ejecutar tests en todos los módulos
	# TODO: for mod in $(MODULES); do $(MAKE) -C $$mod test ENV=$(ENV); done

# --------------------------------------------------------------------------
# TODO 4: Implementa 'deploy' recursivo pasando ENV a cada submake
# --------------------------------------------------------------------------
deploy: ## Desplegar todos los módulos (requiere ENV != development)
	# TODO: for mod in $(MODULES); do $(MAKE) -C $$mod deploy ENV=$(ENV); done

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
