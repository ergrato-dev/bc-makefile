.PHONY: all clean test deploy help
.DEFAULT_GOAL := help

MODULES := api worker frontend
ENV     ?= development

all: ## Construir todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod build; \
	done

clean: ## Limpiar artefactos de todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod clean; \
	done

test: ## Ejecutar tests en todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod test ENV=$(ENV); \
	done

deploy: ## Desplegar todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod deploy ENV=$(ENV); \
	done

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
