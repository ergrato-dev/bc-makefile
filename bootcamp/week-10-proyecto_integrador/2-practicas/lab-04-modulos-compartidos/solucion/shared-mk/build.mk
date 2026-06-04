# shared-mk/build.mk — Módulo de build reutilizable
.PHONY: build clean package

VERSION ?= 1.0.0

build: ## Construir el servicio
	@echo "[$(APP_NAME)] Build $(VERSION)"

clean: ## Limpiar artefactos de build
	@echo "[$(APP_NAME)] Limpiando artefactos ..."

package: ## Empaquetar artefactos para distribución
	@echo "[$(APP_NAME)] Empaquetando $(APP_NAME)-$(VERSION).tar.gz"
	@tar -czf $(APP_NAME)-$(VERSION).tar.gz --exclude='*.tar.gz' .
