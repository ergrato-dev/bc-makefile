SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development
LOCAL_OVERRIDE := false

# --------------------------------------------------------------------------
# TODO 1 (paso 3): importa mk/build.mk, mk/test.mk y mk/deploy.mk con
#         'include', y mk/local.mk con '-include' (opcional).
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2 (paso 7): VERSION ya no se escribe a mano. Añade 'include mk/version.mk'
#         (antes de los módulos) y una regla que genere mk/version.mk a
#         partir del archivo VERSION:
#           - prerrequisito: VERSION
#           - imprime "[version] regenerando <target> desde <prerrequisito>"
#           - escribe la línea  VERSION := <contenido de VERSION>  en el target
#         Pista: dentro de la receta, $$(cat $<) llega al shell como $(cat VERSION).
# --------------------------------------------------------------------------

all: build test ## Construir y testear

info: ## Mostrar configuración
	$(info APP_NAME       = $(APP_NAME))
	$(info VERSION        = $(VERSION))
	$(info ENV            = $(ENV))
	$(info LOCAL_OVERRIDE = $(LOCAL_OVERRIDE))
	@echo "Info mostrada."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
