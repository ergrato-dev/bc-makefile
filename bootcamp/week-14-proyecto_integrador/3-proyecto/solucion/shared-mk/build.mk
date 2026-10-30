# shared-mk/build.mk — Módulo de build reutilizable
# Requiere: APP_NAME. Define BUILD_DIR y STAMPS para el resto de módulos.
.PHONY: build clean package deps

VERSION   ?= 1.0.0
BUILD_DIR ?= build
STAMPS    := $(BUILD_DIR)/.stamps

build: ## Construir el servicio
	@echo "[$(APP_NAME)] Build $(VERSION)"

# Sin receta: python.mk y node.mk le añaden su stamp como prerrequisito.
deps: ## Instalar dependencias (solo si cambió el lockfile)

# Guarda: un BUILD_DIR vacío por un typo o un `make clean BUILD_DIR=` no puede
# convertirse en `rm -rf ''` ni en algo peor.
clean: ## Limpiar artefactos
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
	@echo "[$(APP_NAME)] Limpiando ..."

package: build ## Empaquetar para distribución
	@mkdir -p $(BUILD_DIR)
	@echo "[$(APP_NAME)] Empaquetando $(BUILD_DIR)/$(APP_NAME)-$(VERSION).tar.gz"
	@tar -czf $(BUILD_DIR)/$(APP_NAME)-$(VERSION).tar.gz --exclude='./$(BUILD_DIR)' .

$(STAMPS)/:
	mkdir -p $@
