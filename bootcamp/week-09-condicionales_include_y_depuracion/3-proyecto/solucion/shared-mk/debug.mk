# Módulo compartido: debug.mk
# Variables requeridas: APP_NAME, VERSION, ENV, BUILD_DIR, ARTIFACT
# Targets: debug-vars, validate

.PHONY: debug-vars validate

debug-vars: ## Mostrar variables de diagnóstico
	$(info APP_NAME      = $(APP_NAME))
	$(info VERSION       = $(VERSION))
	$(info ENV           = $(ENV))
	$(info BUILD_DIR     = $(BUILD_DIR))
	$(info ARTIFACT      = $(ARTIFACT))
	$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
	@echo "Diagnóstico completado."

validate: ## Validar que las variables requeridas están definidas
	@[ -n "$(APP_NAME)" ] || \
		{ echo "ERROR: APP_NAME no puede estar vacía. Defínela en el Makefile del módulo"; exit 1; }
	@[ -n "$(VERSION)" ] || \
		{ echo "ERROR: VERSION no puede estar vacía. Defínela en el Makefile del módulo"; exit 1; }
	@[ -n "$(SRCS)" ] || \
		{ echo "ERROR: $(SRC_DIR)/ no tiene fuentes"; exit 1; }
	@echo "[$(APP_NAME)] Validación OK"
