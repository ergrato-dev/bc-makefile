# Módulo: build.mk — targets de compilación
# Requiere (definidas antes del include): APP_NAME, VERSION

ARTIFACT_NAME := $(APP_NAME)-$(VERSION)

.PHONY: build clean

# --------------------------------------------------------------------------
# TODO 3 (paso 4): 'build' imprime "[build] Compilando <ARTIFACT_NAME>"
#                  'clean' imprime "[build] Limpiando artefactos de <APP_NAME>"
# --------------------------------------------------------------------------
build: ## Compilar el proyecto

clean: ## Eliminar artefactos de compilación
