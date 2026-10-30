.PHONY: env-check env-show env-dev env-staging env-prod help
.DEFAULT_GOAL := help

APP_NAME  := mi-app
ENV_FILE  := .env
ENV       ?= development

-include $(ENV_FILE)
export

guard-%:
	@test -n "${$*}" || \
		(echo "ERROR: $* no definida. Copia .env.example → .env y asigna un valor"; exit 1)

env-check: guard-APP_NAME guard-DB_URL guard-API_KEY ## Verificar que las variables de entorno requeridas están definidas
	@echo "Variables de entorno OK"

env-show: ## Mostrar variables de entorno activas (secretos enmascarados)
	@echo "=== Variables de entorno ==="
	@echo "APP_NAME = $(APP_NAME)"
	@echo "ENV      = $(ENV)"
	@echo "DB_URL   = $(DB_URL)"
	@printf "API_KEY  = %s***\n" "$(shell printf '%.6s' '$(API_KEY)')"

env-dev: ## Activar entorno development
	@ENV_FILE=.env.dev $(MAKE) -e ENV=development _show-env

env-staging: ## Activar entorno staging
	@ENV_FILE=.env.staging $(MAKE) -e ENV=staging _show-env

env-prod: ## Activar entorno production
	@ENV_FILE=.env.prod $(MAKE) -e ENV=production _show-env

_show-env:
	@echo "Entorno: $(ENV)"
	@test -f $(ENV_FILE) && echo "Archivo: $(ENV_FILE)" || echo "Archivo: no encontrado (usando valores por defecto)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
