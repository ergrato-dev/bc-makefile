# Módulo compartido: debug.mk
# Variables requeridas: APP_NAME, VERSION, ENV

.PHONY: debug-vars validate

# --------------------------------------------------------------------------
# TODO: Implementa 'debug-vars' usando $(info ...) para mostrar:
#       APP_NAME, VERSION, ENV, MAKEFILE_LIST
#       Una línea de receta por variable, por ejemplo:
#       $(info APP_NAME     = $(APP_NAME))
#       (No lo dejes en un comentario con TAB: Make expande $(...) también ahí)
# --------------------------------------------------------------------------
debug-vars: ## Mostrar variables de diagnóstico
	@echo "Diagnóstico completado."

# --------------------------------------------------------------------------
# TODO: Implementa 'validate' que falla con mensaje claro si APP_NAME está vacía
#       y si VERSION está vacía. Si todo OK, imprime "Validación OK"
#       Por ejemplo: @[ -n "$(APP_NAME)" ] || (echo "ERROR: ..."; exit 1)
# --------------------------------------------------------------------------
validate: ## Validar que las variables requeridas están definidas
	@echo "Validación OK"
