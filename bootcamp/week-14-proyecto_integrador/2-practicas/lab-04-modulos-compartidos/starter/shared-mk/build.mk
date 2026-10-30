# shared-mk/build.mk — Módulo de build reutilizable
# Importar con: include ../shared-mk/build.mk
# Requiere: APP_NAME, VERSION

.PHONY: build clean package

VERSION ?= 1.0.0

# TODO: implementar target build
# Debe imprimir: [$(APP_NAME)] Build $(VERSION)
build: ## Construir el servicio

# TODO: implementar target clean
# Debe imprimir: [$(APP_NAME)] Limpiando artefactos ...
clean: ## Limpiar artefactos de build

# TODO: implementar target package
# Debe crear un archivo tar.gz: $(APP_NAME)-$(VERSION).tar.gz
# Imprimir: [$(APP_NAME)] Empaquetando $(APP_NAME)-$(VERSION).tar.gz
package: ## Empaquetar artefactos para distribución
