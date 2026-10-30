.PHONY: help
.DEFAULT_GOAL := help

APP_NAME := infra
VERSION  := 1.0.0

include ../shared-mk/build.mk
include ../shared-mk/deploy.mk
include ../shared-mk/ci.mk

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
