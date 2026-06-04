.PHONY: all build deploy info help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

ifeq ($(ENV), production)
  BUILD_FLAGS := --release
else ifeq ($(ENV), staging)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug
endif

ifdef CI
  $(info Modo CI activado — paralelo habilitado)
  MAKEFLAGS += -j4
endif

info: ## Mostrar configuración actual del entorno
	$(info APP_NAME    = $(APP_NAME))
	$(info ENV         = $(ENV))
	$(info BUILD_FLAGS = $(BUILD_FLAGS))
	@echo "Configuración mostrada."

build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) con $(BUILD_FLAGS)"

deploy: ## Desplegar (no permitido en development)
	@[ "$(ENV)" != "development" ] || \
		(echo "ERROR: deploy no permitido en development"; exit 1)
	@echo "Desplegando en $(ENV)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
