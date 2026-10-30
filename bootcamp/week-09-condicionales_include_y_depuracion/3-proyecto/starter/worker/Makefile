# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all help
.DEFAULT_GOAL := help

APP_NAME := worker
VERSION  := 1.0.0
WORKERS  := 4
ENV      ?= development

# TODO: include ../shared-mk/build.mk
# TODO: include ../shared-mk/test.mk
# TODO: include ../shared-mk/deploy.mk
# TODO: include ../shared-mk/debug.mk

all: build ## Construir este módulo

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
