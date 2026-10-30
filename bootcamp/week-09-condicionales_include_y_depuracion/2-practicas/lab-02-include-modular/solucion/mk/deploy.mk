# Módulo: deploy.mk — targets de despliegue
# Requiere: APP_NAME, VERSION, ENV

.PHONY: deploy

deploy: ## Desplegar en el entorno activo (ENV=development por defecto)
	@echo "[deploy] Desplegando $(APP_NAME) $(VERSION) en $(ENV)"
