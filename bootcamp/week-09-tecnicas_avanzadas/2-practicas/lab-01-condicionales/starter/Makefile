.PHONY: all build deploy info help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

# --------------------------------------------------------------------------
# TODO 1: Implementa un bloque ifeq/else/endif que defina BUILD_FLAGS:
#         - Si ENV es "production" o "staging": BUILD_FLAGS := --release
#         - Si ENV es cualquier otro valor:      BUILD_FLAGS := --debug
# --------------------------------------------------------------------------

# TODO: bloque condicional aquí

# --------------------------------------------------------------------------
# TODO 2: Detecta si la variable CI está definida (usa ifdef).
#         Si está definida, imprime el mensaje usando $(info ...) y
#         agrega -j4 a MAKEFLAGS.
# --------------------------------------------------------------------------

# TODO: bloque ifdef CI aquí

# --------------------------------------------------------------------------
# TODO 3: Implementa el target 'info' que imprime:
#         APP_NAME, ENV y BUILD_FLAGS usando $(info ...)
#         Termina con @echo "Configuración mostrada."
# --------------------------------------------------------------------------
info: ## Mostrar configuración actual del entorno
	# TODO: $(info APP_NAME = ...)
	# TODO: $(info ENV      = ...)
	# TODO: $(info BUILD_FLAGS = ...)
	@echo "Configuración mostrada."

# --------------------------------------------------------------------------
# TODO 4: Implementa 'build' que imprime "Compilando <APP_NAME> con <BUILD_FLAGS>"
# --------------------------------------------------------------------------
build: ## Compilar el proyecto
	# TODO: @echo "Compilando ..."

# --------------------------------------------------------------------------
# TODO 5: Implementa 'deploy' que:
#         - Falla con $(error ...) si ENV == "development"
#         - Imprime "Desplegando en <ENV>" si ENV es otro valor
# --------------------------------------------------------------------------
deploy: ## Desplegar (no permitido en development)
	# TODO: ifeq condicional de receta no funciona — usa $(if ...) o
	#       un truco de shell: @[ "$(ENV)" != "development" ] || (echo "ERROR: ..."; exit 1)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
