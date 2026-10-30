# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all help
.DEFAULT_GOAL := help

# Variables específicas de este módulo
APP_NAME := api
VERSION  := 1.0.0
PORT     := 8080
ENV      ?= development

# --------------------------------------------------------------------------
# TODO: Importa los 4 módulos compartidos desde shared-mk/
#       La ruta es relativa al directorio donde corre Make. El Makefile
#       raíz entra con -C api, así que la ruta es ../shared-mk/build.mk
# --------------------------------------------------------------------------
# TODO: include ../shared-mk/build.mk
# TODO: include ../shared-mk/test.mk
# TODO: include ../shared-mk/deploy.mk
# TODO: include ../shared-mk/debug.mk

all: build ## Construir este módulo

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
