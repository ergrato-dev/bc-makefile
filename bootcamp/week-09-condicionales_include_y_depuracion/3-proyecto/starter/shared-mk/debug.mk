# Módulo compartido: debug.mk
# Variables requeridas: APP_NAME, VERSION, ENV, BUILD_DIR, ARTIFACT
# Targets: debug-vars, validate

.PHONY: debug-vars validate

# --------------------------------------------------------------------------
# TODO 1: 'debug-vars' muestra con $(info ...) una línea por variable:
#         APP_NAME, VERSION, ENV, BUILD_DIR, ARTIFACT y MAKEFILE_LIST,
#         con el formato "NOMBRE = valor". Por ejemplo, como línea de receta:
#           $(info APP_NAME      = $(APP_NAME))
#         No dejes ese ejemplo en un comentario con TAB: Make expande
#         $(...) también ahí.
# --------------------------------------------------------------------------
debug-vars: ## Mostrar variables de diagnóstico
	@echo "Diagnóstico completado."

# --------------------------------------------------------------------------
# TODO 2: 'validate' sale con error y un mensaje que nombra la variable si
#         APP_NAME o VERSION están vacías ("ERROR: VERSION no puede estar
#         vacía. ..."), o si SRCS está vacía. Si todo va bien imprime
#         "[<APP_NAME>] Validación OK".
#         Patrón: @[ -n "$(VERSION)" ] || { echo "ERROR: ..."; exit 1; }
# --------------------------------------------------------------------------
validate: ## Validar que las variables requeridas están definidas
