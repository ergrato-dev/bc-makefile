SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build deploy info help
.DEFAULT_GOAL := help

APP_NAME   := mi-app
ENV        ?= development
VALID_ENVS := development staging production

# Validación al leer el archivo: un ENV mal escrito no llega a ninguna receta.
ifeq ($(filter $(ENV),$(VALID_ENVS)),)
  $(error ENV='$(ENV)' no es válido. Usa uno de: $(VALID_ENVS))
endif

ifeq ($(ENV),production)
  BUILD_FLAGS := --release
else ifeq ($(ENV),staging)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug
endif

# ifdef es falso con CI= (definida pero vacía). $(origin) sí las distingue.
ifdef CI
  $(info Modo CI activado — paralelo habilitado)
  MAKEFLAGS += -j4
endif

# FIX: el comentario iba en la misma línea y el espacio previo formaba parte
# del valor ("eu "), así que el ifeq nunca era verdadero.
# región por defecto
REGION := eu

ifeq ($(REGION),eu)
  ENDPOINT := https://eu.api.example.com
else
  ENDPOINT := https://us.api.example.com
endif

info: ## Mostrar configuración actual del entorno
	$(info APP_NAME    = $(APP_NAME))
	$(info ENV         = $(ENV))
	$(info BUILD_FLAGS = $(BUILD_FLAGS))
	$(info CI          = [$(CI)] origin=$(origin CI))
	$(info ENDPOINT    = $(ENDPOINT))
	@echo "Configuración mostrada."

build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) con $(BUILD_FLAGS)"

deploy: ## Desplegar (no permitido en development)
	@[ "$(ENV)" != "development" ] || \
		{ echo "ERROR: deploy no permitido en development"; exit 1; }
	@echo "Desplegando en $(ENV) ($(ENDPOINT))"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
