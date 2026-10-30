SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all help
.DEFAULT_GOAL := help

APP_NAME  := frontend
VERSION   := 1.0.0
BUILD_DIR := dist
ENV       ?= development

include ../shared-mk/build.mk
include ../shared-mk/test.mk
include ../shared-mk/deploy.mk
include ../shared-mk/debug.mk

all: build ## Construir este módulo

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
