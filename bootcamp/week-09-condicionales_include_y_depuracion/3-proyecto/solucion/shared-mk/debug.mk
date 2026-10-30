# Módulo compartido: debug.mk
# Variables requeridas: APP_NAME, VERSION, ENV

.PHONY: debug-vars validate

debug-vars: ## Mostrar variables de diagnóstico
	$(info APP_NAME     = $(APP_NAME))
	$(info VERSION      = $(VERSION))
	$(info ENV          = $(ENV))
	$(info MAKEFILE_LIST= $(MAKEFILE_LIST))
	@echo "Diagnóstico completado."

validate: ## Validar que las variables requeridas están definidas
	@[ -n "$(APP_NAME)" ] || \
		(echo "ERROR: APP_NAME no puede estar vacía"; exit 1)
	@[ -n "$(VERSION)" ] || \
		(echo "ERROR: VERSION no puede estar vacía"; exit 1)
	@echo "Validación OK"
