SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# Guarda de versión: se evalúa al leer el archivo, antes de cualquier target.
# $(sort) ordena como texto: vale para 3.81 < 4.3 < 4.4.1, no para un futuro 4.10.
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Este proyecto requiere GNU Make >= $(MIN_MAKE_VERSION) y estás usando $(MAKE_VERSION). En macOS: brew install make y ejecuta gmake)
endif

.PHONY: all clean test deploy doctor help
.DEFAULT_GOAL := help

MODULES := api worker frontend
GOALS   := build clean test deploy validate
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

doctor: $(addsuffix /validate,$(MODULES)) ## Diagnosticar Make y validar cada módulo
	$(info MAKE_VERSION  = $(MAKE_VERSION) (mínimo $(MIN_MAKE_VERSION)))
	$(info MAKECMDGOALS  = $(MAKECMDGOALS))
	$(info MODULES       = $(MODULES))
	$(info ENV           = $(ENV))
	@echo "Diagnóstico OK"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
