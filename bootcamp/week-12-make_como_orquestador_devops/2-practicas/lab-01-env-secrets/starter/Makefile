SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: env-check env-show env-dev env-staging env-prod help
.DEFAULT_GOAL := help

APP_NAME  := mi-app
ENV_FILE  ?= .env
ENV       ?= development

# Carga .env si existe (no falla si no existe).
# OJO: se parsea como Makefile. Ver Contexto del README.
-include $(ENV_FILE)

# --------------------------------------------------------------------------
# TODO 1: Exporta SOLO las variables que las recetas necesitan (DB_URL y
#         API_KEY). Nunca `export` sin argumentos: mandaría todos los
#         secretos a cada subproceso.
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Implementa guard-% en Make, sin pasar el valor por el shell:
#         $(if $($*),:,$(error $* no definida. Copia .env.example a .env y asigna un valor))
# --------------------------------------------------------------------------
guard-%:
	@echo "TODO: implementa guard-$*"

# --------------------------------------------------------------------------
# TODO 3: env-check depende de guard-DB_URL y guard-API_KEY
# --------------------------------------------------------------------------
env-check: ## Verificar que las variables de entorno requeridas están definidas
	@echo "Variables de entorno OK"

# --------------------------------------------------------------------------
# TODO 4: env-show. Los secretos se leen como variables de entorno del
#         shell ($$API_KEY), NUNCA pegados en el comando con $(API_KEY):
#           @printf 'API_KEY  = %s***\n' "$${API_KEY:0:4}"
#         DB_URL debe ocultar usuario y contraseña (user:pass@ -> ***@).
# --------------------------------------------------------------------------
env-show: ## Mostrar variables de entorno activas (secretos enmascarados)
	@echo "=== Variables de entorno ==="
	@echo "APP_NAME = $(APP_NAME)"
	@echo "ENV      = $(ENV)"

# --------------------------------------------------------------------------
# TODO 5: env-dev, env-staging y env-prod relanzan Make con otro archivo:
#           @$(MAKE) --no-print-directory ENV_FILE=.env.dev ENV=development _show-env
#         y _show-env imprime "Entorno: <ENV>" y el archivo cargado.
# --------------------------------------------------------------------------
env-dev: ## Activar entorno development

env-staging: ## Activar entorno staging

env-prod: ## Activar entorno production

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
