SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean test deploy help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test deploy
ENV     ?= development

# Un target phony por módulo y meta (api/build, worker/test...): un fallo en
# cualquier módulo detiene el build. Un bucle for se lo tragaría.
MODULE_TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(MODULES)))
.PHONY: $(MODULE_TARGETS)

$(MODULE_TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F) ENV=$(ENV)

all: $(addsuffix /build,$(MODULES)) ## Construir todos los módulos

clean: $(addsuffix /clean,$(MODULES)) ## Limpiar artefactos de todos los módulos

test: $(addsuffix /test,$(MODULES)) ## Ejecutar tests en todos los módulos

deploy: $(addsuffix /deploy,$(MODULES)) ## Desplegar todos los módulos

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
