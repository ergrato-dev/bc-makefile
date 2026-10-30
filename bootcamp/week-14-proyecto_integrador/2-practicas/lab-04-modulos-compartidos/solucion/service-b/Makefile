.PHONY: help
.DEFAULT_GOAL := help

APP_NAME := service-b
VERSION  := 2.3.1

include ../shared-mk/build.mk
include ../shared-mk/test.mk
include ../shared-mk/docker.mk

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
