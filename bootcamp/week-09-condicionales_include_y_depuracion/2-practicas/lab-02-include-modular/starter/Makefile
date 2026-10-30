.PHONY: all info help
.DEFAULT_GOAL := help

APP_NAME := mi-app
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)
ENV      ?= development

# --------------------------------------------------------------------------
# TODO 1: Importa los módulos mk/build.mk, mk/test.mk y mk/deploy.mk
#         con 'include'. Importa mk/local.mk con '-include' (opcional).
# --------------------------------------------------------------------------
# TODO: include mk/build.mk
# TODO: include mk/test.mk
# TODO: include mk/deploy.mk
# TODO: -include mk/local.mk

all: build test ## Construir y testear

info: ## Mostrar configuración
	$(info APP_NAME      = $(APP_NAME))
	$(info VERSION       = $(VERSION))
	$(info ENV           = $(ENV))
	$(info LOCAL_OVERRIDE= $(LOCAL_OVERRIDE))
	@echo "Info mostrada."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
