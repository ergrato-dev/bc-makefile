.PHONY: env-check env-show env-dev env-staging env-prod help
.DEFAULT_GOAL := help

APP_NAME  := mi-app
ENV_FILE  := .env
ENV       ?= development

# Carga .env si existe (no falla si no existe)
-include $(ENV_FILE)
export

# --------------------------------------------------------------------------
# TODO 1: Implementa el target guard-% que valida que una variable esté
#         definida. Si no lo está, debe imprimir un error y salir con código 1.
#         Sintaxis de uso: guard-NOMBRE_VAR
#         Ejemplo de uso: deploy: guard-API_KEY
# --------------------------------------------------------------------------
guard-%:
	# TODO: completar implementación

# --------------------------------------------------------------------------
# TODO 2: Implementa env-check para validar que APP_NAME, DB_URL y API_KEY
#         estén definidas. Usa guard-% para cada una.
# --------------------------------------------------------------------------
env-check: ## Verificar que las variables de entorno requeridas están definidas
	# TODO: llamar guard-APP_NAME guard-DB_URL guard-API_KEY
	@echo "Variables de entorno OK"

# --------------------------------------------------------------------------
# TODO 3: Implementa env-show para mostrar las variables de entorno.
#         API_KEY debe mostrarse enmascarada (primeros 6 chars + ***)
#         Tip: usa $(shell echo "$(API_KEY)" | cut -c1-6)
# --------------------------------------------------------------------------
env-show: ## Mostrar variables de entorno activas (secretos enmascarados)
	@echo "=== Variables de entorno ==="
	@echo "APP_NAME = $(APP_NAME)"
	@echo "ENV      = $(ENV)"
	# TODO: mostrar DB_URL
	# TODO: mostrar API_KEY enmascarada

# --------------------------------------------------------------------------
# TODO 4: Implementa env-dev, env-staging y env-prod.
#         Cada uno debe cargar su archivo .env.ENTORNO e imprimir el entorno activo.
#         Tip: usa $(MAKE) con ENV=development y -f o recarga variables
# --------------------------------------------------------------------------
env-dev: ## Activar entorno development
	# TODO: cargar .env.dev y mostrar "Entorno: development"

env-staging: ## Activar entorno staging
	# TODO: cargar .env.staging y mostrar "Entorno: staging"

env-prod: ## Activar entorno production
	# TODO: cargar .env.prod y mostrar "Entorno: production"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
