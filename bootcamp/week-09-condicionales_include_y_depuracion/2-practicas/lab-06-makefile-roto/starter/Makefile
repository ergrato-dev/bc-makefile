# Makefile heredado del equipo anterior: 'make ci' no funciona y nadie sabe
# por qué. Arréglalo sin reescribirlo; marca cada corrección con # FIX:.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: ci build test lint deploy help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

include mk/config.mk

ifeq ($(ENV),production)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug

build: ## Compilar el proyecto
        @echo "Compilando $(APP_NMAE) $(BUILD_FLAGS)"

VERSION = v$(VERSION)

test: ## Ejecutar tests
	@echo "Tests OK"

lint: check-syntax ## Verificar estilo
	@echo "Lint OK"

ci: build test lint deploy ## Ejecutar pipeline completo
	@echo "CI completo"

# deploy va siempre a production y en production debe llevar --confirm
deploy: ENV := production
ifeq ($(ENV),production)
  DEPLOY_FLAGS := --confirm
endif

deploy: ci ## Desplegar en production
	@echo "Desplegando $(APP_NAME) $(VERSION) en $(ENV) $(DEPLOY_FLAGS)"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
