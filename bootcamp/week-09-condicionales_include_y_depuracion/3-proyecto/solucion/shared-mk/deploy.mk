# Módulo compartido: deploy.mk
# Variables requeridas: APP_NAME, VERSION, ENV
# Targets: deploy, rollback

.PHONY: deploy rollback

# El ifeq se evalúa al leer el archivo: ENV tiene que llegar por línea de
# comandos o estar definida antes del include, no como variable de target.
deploy: ## Desplegar en ENV (en production marca CONFIRMADO)

ifeq ($(ENV),production)
deploy:
	@echo "[$(APP_NAME)] Desplegando en production (CONFIRMADO)"
else
deploy:
	@echo "[$(APP_NAME)] Desplegando en $(ENV)"
endif

rollback: ## Revertir al despliegue anterior
	@echo "[$(APP_NAME)] Rollback a versión anterior"
