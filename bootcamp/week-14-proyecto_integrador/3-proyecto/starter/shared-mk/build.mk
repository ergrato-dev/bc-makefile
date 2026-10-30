# shared-mk/build.mk
# Requiere: APP_NAME. Define BUILD_DIR y STAMPS para el resto de módulos.
.PHONY: build clean package deps

VERSION   ?= 1.0.0
BUILD_DIR ?= build
STAMPS    := $(BUILD_DIR)/.stamps

# TODO: implementar build, clean, package
# build:   imprime [$(APP_NAME)] Build $(VERSION)
# clean:   guarda $(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta)),
#          después rm -rf -- '$(BUILD_DIR)' e imprime [$(APP_NAME)] Limpiando ...
# package: crea $(BUILD_DIR)/$(APP_NAME)-$(VERSION).tar.gz
build: ## Construir el servicio

# deps no lleva receta: python.mk y node.mk le añaden su stamp.
deps: ## Instalar dependencias (solo si cambió el lockfile)

clean: ## Limpiar artefactos

package: ## Empaquetar para distribución

# TODO: regla para crear el directorio $(STAMPS)/ (mkdir -p $@)
