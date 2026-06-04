# Módulo: deploy.mk — targets de despliegue
# Importar desde el Makefile principal con: include mk/deploy.mk

.PHONY: deploy

# --------------------------------------------------------------------------
# TODO 5: Implementa el target 'deploy' que imprime:
#         "[deploy] Desplegando en <ENV>"
#         ENV viene del Makefile principal (ya definida antes del include)
# --------------------------------------------------------------------------
deploy: ## Desplegar en el entorno activo (ENV=development por defecto)
	# TODO: @echo "[deploy] Desplegando en ..."
