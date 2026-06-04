# Módulo compartido: build.mk
# Variables requeridas: APP_NAME, VERSION

.PHONY: build clean package

build: ## Compilar el módulo
	@echo "[$(APP_NAME)] Compilando $(APP_NAME) $(VERSION)"

clean: ## Limpiar artefactos de compilación
	@echo "[$(APP_NAME)] Limpiando artefactos"

package: build ## Empaquetar artefacto
	@echo "[$(APP_NAME)] Empaquetando $(APP_NAME)-$(VERSION).tar.gz"
