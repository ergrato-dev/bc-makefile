# Módulo compartido: deploy.mk
# Variables requeridas: APP_NAME, VERSION, ENV
# Targets: deploy, rollback

.PHONY: deploy rollback

# Esta línea solo documenta el target para 'make help'; las recetas van abajo.
deploy: ## Desplegar en ENV (en production marca CONFIRMADO)

# --------------------------------------------------------------------------
# TODO 1: Con ifeq/else/endif define la receta de 'deploy':
#         - en production: "[<APP_NAME>] Desplegando en production (CONFIRMADO)"
#         - en cualquier otro: "[<APP_NAME>] Desplegando en <ENV>"
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: 'rollback' imprime "[<APP_NAME>] Rollback a versión anterior"
# --------------------------------------------------------------------------
rollback: ## Revertir al despliegue anterior
