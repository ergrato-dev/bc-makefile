# Módulo compartido: build.mk
# Variables requeridas en el Makefile importador: APP_NAME, VERSION

.PHONY: build clean package

# --------------------------------------------------------------------------
# TODO: Implementa 'build' que imprime "[<APP_NAME>] Compilando <APP_NAME> <VERSION>"
# --------------------------------------------------------------------------
build: ## Compilar el módulo
	# TODO

# --------------------------------------------------------------------------
# TODO: Implementa 'clean' que imprime "[<APP_NAME>] Limpiando artefactos"
# --------------------------------------------------------------------------
clean: ## Limpiar artefactos de compilación
	# TODO

# --------------------------------------------------------------------------
# TODO: Implementa 'package' que imprime "[<APP_NAME>] Empaquetando <APP_NAME>-<VERSION>.tar.gz"
# --------------------------------------------------------------------------
package: build ## Empaquetar artefacto
	# TODO
