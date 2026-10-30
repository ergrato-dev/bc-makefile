# shared-mk/deploy.mk — Módulo de deploy reutilizable
.PHONY: deploy rollback

ENV     ?= development
CONFIRM ?=

deploy: ## Desplegar el servicio
ifeq ($(ENV), production)
ifneq ($(CONFIRM), yes)
	$(error ERROR: producción requiere CONFIRM=yes)
endif
endif
	@echo "[$(APP_NAME)] Desplegando en $(ENV)"

rollback: ## Revertir último despliegue
	@echo "[$(APP_NAME)] Rollback en $(ENV) ..."
