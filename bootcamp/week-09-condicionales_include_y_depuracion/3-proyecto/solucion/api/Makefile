SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all help
.DEFAULT_GOAL := help

APP_NAME := api
VERSION  := 1.0.0
PORT     := 8080
ENV      ?= development

include ../shared-mk/build.mk
include ../shared-mk/test.mk
include ../shared-mk/deploy.mk
include ../shared-mk/debug.mk

all: build ## Construir este módulo

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
