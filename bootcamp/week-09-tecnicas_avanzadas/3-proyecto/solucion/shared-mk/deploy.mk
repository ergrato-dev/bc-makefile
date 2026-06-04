# Módulo compartido: deploy.mk
# Variables requeridas: APP_NAME, VERSION, ENV

.PHONY: deploy rollback

ifeq ($(ENV), production)
deploy: ## Desplegar en production
	@echo "[$(APP_NAME)] Desplegando en production (CONFIRMADO)"
else
deploy: ## Desplegar en el entorno activo
	@echo "[$(APP_NAME)] Desplegando en $(ENV)"
endif

rollback: ## Revertir al despliegue anterior
	@echo "[$(APP_NAME)] Rollback a versión anterior"
