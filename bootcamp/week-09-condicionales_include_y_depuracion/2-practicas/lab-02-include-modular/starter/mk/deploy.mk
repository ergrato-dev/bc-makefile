# Módulo: deploy.mk — targets de despliegue
# Requiere: APP_NAME, VERSION, ENV

.PHONY: deploy

# --------------------------------------------------------------------------
# TODO 5 (paso 4): 'deploy' imprime "[deploy] Desplegando <APP_NAME> <VERSION> en <ENV>"
# --------------------------------------------------------------------------
deploy: ## Desplegar en el entorno activo (ENV=development por defecto)
