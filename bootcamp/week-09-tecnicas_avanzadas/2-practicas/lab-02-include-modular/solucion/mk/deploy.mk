# Módulo: deploy.mk — targets de despliegue

.PHONY: deploy

deploy: ## Desplegar en el entorno activo (ENV=development por defecto)
	@echo "[deploy] Desplegando en $(ENV)"
