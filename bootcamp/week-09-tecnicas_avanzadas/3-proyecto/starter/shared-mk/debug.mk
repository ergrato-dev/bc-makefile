# Módulo compartido: debug.mk
# Variables requeridas: APP_NAME, VERSION, ENV

.PHONY: debug-vars validate

# --------------------------------------------------------------------------
# TODO: Implementa 'debug-vars' usando $(info ...) para mostrar:
#       APP_NAME, VERSION, ENV, MAKEFILE_LIST
# --------------------------------------------------------------------------
debug-vars: ## Mostrar variables de diagnóstico
	# TODO: $(info APP_NAME = ...)
	# TODO: $(info VERSION  = ...)
	# TODO: $(info ENV      = ...)
	@echo "Diagnóstico completado."

# --------------------------------------------------------------------------
# TODO: Implementa 'validate' que falla con mensaje claro si APP_NAME está vacía
#       y si VERSION está vacía. Si todo OK, imprime "Validación OK"
# --------------------------------------------------------------------------
validate: ## Validar que las variables requeridas están definidas
	# TODO: @[ -n "$(APP_NAME)" ] || ...
	# TODO: @[ -n "$(VERSION)" ] || ...
	@echo "Validación OK"
