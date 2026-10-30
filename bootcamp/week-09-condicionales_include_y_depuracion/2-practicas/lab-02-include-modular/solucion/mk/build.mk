# Módulo: build.mk — targets de compilación
# Requiere (definidas antes del include): APP_NAME, VERSION

ARTIFACT_NAME := $(APP_NAME)-$(VERSION)

.PHONY: build clean

build: ## Compilar el proyecto
	@echo "[build] Compilando $(ARTIFACT_NAME)"

clean: ## Eliminar artefactos de compilación
	@echo "[build] Limpiando artefactos de $(APP_NAME)"
