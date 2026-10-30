SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help
.DEFAULT_GOAL := help

APP_NAME   := backend
IMAGE_NAME := mi-plataforma-backend
VERSION    := 1.0.0

include ../shared-mk/build.mk
include ../shared-mk/test.mk
include ../shared-mk/docker.mk
include ../shared-mk/deploy.mk
include ../shared-mk/ci.mk

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
