.PHONY: build validate debug-vars debug-deps debug-all help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) $(VERSION) [$(ENV)]"

debug-vars: ## Mostrar variables clave para diagnóstico
	$(info APP_NAME      = $(APP_NAME))
	$(info ENV           = $(ENV))
	$(info VERSION       = $(VERSION))
	$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
	@echo "Variables mostradas."

debug-deps: ## Mostrar lógica de reconstrucción de dependencias
	@$(MAKE) build --debug=b

validate: ## Validar que APP_NAME esté definida
	@[ -n "$(APP_NAME)" ] || \
		(echo "ERROR: APP_NAME no puede estar vacía"; exit 1)
	@echo "Validación OK"

debug-all: ## Ejecutar todos los diagnósticos
	@$(MAKE) debug-vars
	@$(MAKE) validate
	@$(MAKE) debug-deps
	@echo "Diagnóstico completo."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
