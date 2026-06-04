# Módulo: build.mk — targets de compilación

.PHONY: build clean

build: ## Compilar el proyecto
	@echo "[build] Compilando $(APP_NAME) $(VERSION)"

clean: ## Eliminar artefactos de compilación
	@echo "[build] Limpiando artefactos de $(APP_NAME)"
