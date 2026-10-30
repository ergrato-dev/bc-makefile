SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: env-check env-show env-dev env-staging env-prod help
.DEFAULT_GOAL := help

APP_NAME  := mi-app
ENV_FILE  ?= .env
ENV       ?= development

# -include no falla si el archivo no existe. OJO: .env se parsea como
# Makefile: un `$` en un valor se expande, las comillas quedan literales,
# `#` corta el valor y `$(shell ...)` se ejecuta. Solo incluye .env que
# controles, con valores sin `$` ni comillas.
-include $(ENV_FILE)

# Solo se exporta lo que las recetas necesitan. Un `export` sin argumentos
# mandaría todas las variables (secretos incluidos) a cada subproceso.
export DB_URL API_KEY

# La comprobación ocurre en Make, sin pasar el valor por el shell.
guard-%:
	@$(if $($*),:,$(error $* no definida. Copia .env.example a .env y asigna un valor))

env-check: guard-DB_URL guard-API_KEY ## Verificar que las variables de entorno requeridas están definidas
	@echo "Variables de entorno OK"

# Los secretos llegan al shell como variables de entorno ($$API_KEY), nunca
# pegados en el texto del comando: un `'` en el valor no rompe nada.
env-show: guard-DB_URL guard-API_KEY ## Mostrar variables de entorno activas (secretos enmascarados)
	@echo "=== Variables de entorno ==="
	@echo "APP_NAME = $(APP_NAME)"
	@echo "ENV      = $(ENV)"
	@printf 'DB_URL   = %s\n' "$$(sed -E 's#://[^@/]*@#://***@#' <<<"$$DB_URL")"
	@printf 'API_KEY  = %s***\n' "$${API_KEY:0:4}"

env-dev: ## Activar entorno development
	@$(MAKE) --no-print-directory ENV_FILE=.env.dev ENV=development _show-env

env-staging: ## Activar entorno staging
	@$(MAKE) --no-print-directory ENV_FILE=.env.staging ENV=staging _show-env

env-prod: ## Activar entorno production
	@$(MAKE) --no-print-directory ENV_FILE=.env.prod ENV=production _show-env

.PHONY: _show-env
_show-env:
	@echo "Entorno: $(ENV)"
	@echo "Archivo: $(if $(wildcard $(ENV_FILE)),$(ENV_FILE),no encontrado (usando valores por defecto))"

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
