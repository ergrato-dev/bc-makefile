.PHONY: build validate debug-vars debug-deps debug-all help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) $(VERSION) [$(ENV)]"

# --------------------------------------------------------------------------
# TODO 1: Implementa 'debug-vars' que imprime las variables clave usando
#         $(info ...) para cada una: APP_NAME, ENV, VERSION, MAKEFILE_LIST
#         Termina con @echo "Variables mostradas."
# --------------------------------------------------------------------------
debug-vars: ## Mostrar variables clave para diagnóstico
	# TODO: $(info APP_NAME     = ...)
	# TODO: $(info ENV          = ...)
	# TODO: $(info VERSION      = ...)
	# TODO: $(info MAKEFILE_LIST= ...)
	@echo "Variables mostradas."

# --------------------------------------------------------------------------
# TODO 2: Implementa 'debug-deps' que corre $(MAKE) build con --debug=b
#         para mostrar la lógica de reconstrucción de dependencias
# --------------------------------------------------------------------------
debug-deps: ## Mostrar lógica de reconstrucción de dependencias
	# TODO: @$(MAKE) build --debug=b

# --------------------------------------------------------------------------
# TODO 3: Implementa 'validate' que falla con $(error ...) si APP_NAME está vacía.
#         Si APP_NAME tiene valor, imprime "Validación OK".
#         Tip: usa ifeq ($(APP_NAME),) ... $(error ...) ... endif al nivel de parsing
#         O bien: usa un test de shell en la receta
# --------------------------------------------------------------------------
validate: ## Validar que APP_NAME esté definida
	# TODO: @[ -n "$(APP_NAME)" ] || (echo "ERROR: APP_NAME no puede estar vacía"; exit 1)
	@echo "Validación OK"

# --------------------------------------------------------------------------
# TODO 4: Implementa 'debug-all' que llama a debug-vars, validate y debug-deps
# --------------------------------------------------------------------------
debug-all: ## Ejecutar todos los diagnósticos
	# TODO: @$(MAKE) debug-vars
	# TODO: @$(MAKE) validate
	# TODO: @$(MAKE) debug-deps
	@echo "Diagnóstico completo."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
