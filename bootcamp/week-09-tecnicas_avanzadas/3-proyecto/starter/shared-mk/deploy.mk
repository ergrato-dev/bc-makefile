# Módulo compartido: deploy.mk
# Variables requeridas: APP_NAME, VERSION, ENV

.PHONY: deploy rollback

# --------------------------------------------------------------------------
# TODO: Implementa 'deploy' con un condicional que:
#       - En production: imprime "[<APP_NAME>] Desplegando en production (CONFIRMADO)"
#       - En cualquier otro entorno: imprime "[<APP_NAME>] Desplegando en <ENV>"
#       Usa ifeq para distinguir el entorno
# --------------------------------------------------------------------------
deploy: ## Desplegar el módulo (ENV=production requiere confirmación)
	# TODO

# --------------------------------------------------------------------------
# TODO: Implementa 'rollback' que imprime "[<APP_NAME>] Rollback a versión anterior"
# --------------------------------------------------------------------------
rollback: ## Revertir al despliegue anterior
	# TODO
