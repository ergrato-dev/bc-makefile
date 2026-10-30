SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info help
.DEFAULT_GOAL := help

# Variables que los módulos necesitan: se definen ANTES de los include,
# porque los módulos las usan con := al leerse.
APP_NAME := mi-app
ENV      ?= development
LOCAL_OVERRIDE := false

# mk/version.mk lo genera la regla de abajo a partir del archivo VERSION.
include mk/version.mk
include mk/build.mk
include mk/test.mk
include mk/deploy.mk
-include mk/local.mk

# Make rehace los makefiles incluidos que tienen regla y se reinicia.
mk/version.mk: VERSION
	@echo "[version] regenerando $@ desde $<"
	@echo "VERSION := $$(cat $<)" > $@

all: build test ## Construir y testear

info: ## Mostrar configuración
	$(info APP_NAME       = $(APP_NAME))
	$(info VERSION        = $(VERSION))
	$(info ENV            = $(ENV))
	$(info LOCAL_OVERRIDE = $(LOCAL_OVERRIDE))
	@echo "Info mostrada."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
