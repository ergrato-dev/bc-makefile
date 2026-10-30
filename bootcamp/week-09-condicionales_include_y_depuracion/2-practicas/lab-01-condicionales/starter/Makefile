SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build deploy info help
.DEFAULT_GOAL := help

APP_NAME   := mi-app
ENV        ?= development
VALID_ENVS := development staging production

# --------------------------------------------------------------------------
# TODO 1 (paso 3): si ENV no es una de VALID_ENVS, detén Make al leer el
#         archivo con $(error ...). Pista: $(filter $(ENV),$(VALID_ENVS))
#         queda vacío cuando ENV no está en la lista.
#         Mensaje: ENV='<valor>' no es válido. Usa uno de: <VALID_ENVS>
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2 (paso 2): bloque ifeq / else ifeq / else / endif que defina BUILD_FLAGS:
#         - production o staging: BUILD_FLAGS := --release
#         - cualquier otro valor:  BUILD_FLAGS := --debug
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 3 (paso 4): si CI tiene valor (ifdef), imprime con $(info ...)
#         "Modo CI activado — paralelo habilitado" y añade -j4 a MAKEFLAGS.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 4 (paso 5): este bloque elige siempre el endpoint de US aunque
#         REGION diga eu. Encuentra por qué y corrígelo sin tocar el ifeq.
# --------------------------------------------------------------------------
REGION := eu # región por defecto

ifeq ($(REGION),eu)
  ENDPOINT := https://eu.api.example.com
else
  ENDPOINT := https://us.api.example.com
endif

# --------------------------------------------------------------------------
# TODO 5 (paso 6): completa 'info' con una línea de receta $(info ...) por
#         dato, en este formato (escríbelas tú: si dejas $(info ...) en un
#         comentario con TAB, Make lo expande igualmente):
#           APP_NAME    = mi-app
#           ENV         = <ENV>
#           BUILD_FLAGS = <BUILD_FLAGS>
#           CI          = [<CI>] origin=<$(origin CI)>
#           ENDPOINT    = <ENDPOINT>
# --------------------------------------------------------------------------
info: ## Mostrar configuración actual del entorno
	@echo "Configuración mostrada."

# --------------------------------------------------------------------------
# TODO 6 (paso 6): 'build' imprime "Compilando <APP_NAME> con <BUILD_FLAGS>"
# --------------------------------------------------------------------------
build: ## Compilar el proyecto

# --------------------------------------------------------------------------
# TODO 7 (paso 7): 'deploy' sale con error y el mensaje
#         "ERROR: deploy no permitido en development" si ENV es development;
#         si no, imprime "Desplegando en <ENV> (<ENDPOINT>)".
#         Un ifeq aquí no sirve para decidir por target: usa un test de shell
#         en la receta: [ "..." != "development" ] || { echo ...; exit 1; }
# --------------------------------------------------------------------------
deploy: ## Desplegar (no permitido en development)

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
