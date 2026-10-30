SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info help
.DEFAULT_GOAL := help

APP_NAME := mi-app
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)
ENV      ?= development

include mk/build.mk
include mk/test.mk
include mk/deploy.mk
-include mk/local.mk

all: build test ## Construir y testear

info: ## Mostrar configuración
	$(info APP_NAME       = $(APP_NAME))
	$(info VERSION        = $(VERSION))
	$(info ENV            = $(ENV))
	$(info LOCAL_OVERRIDE = $(LOCAL_OVERRIDE))
	@echo "Info mostrada."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
