# shared-mk/deploy.mk
.PHONY: deploy rollback

ENV     ?= development
CONFIRM ?=

# TODO: implementar deploy con condicionales de entorno
# Si ENV == production y CONFIRM != "yes":
#   $(error ERROR: producción requiere CONFIRM=yes)
# Imprimir: [$(APP_NAME)] Desplegando en $(ENV)
deploy: ## Desplegar el servicio

# TODO: implementar rollback
# Imprimir: [$(APP_NAME)] Rollback en $(ENV) ...
rollback: ## Revertir último despliegue
