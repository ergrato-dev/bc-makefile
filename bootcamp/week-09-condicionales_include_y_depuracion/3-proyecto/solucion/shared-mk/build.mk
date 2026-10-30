# Módulo compartido: build.mk
# Variables requeridas: APP_NAME, VERSION
# Variables opcionales: BUILD_DIR (por defecto build), SRC_DIR (por defecto src)
# Targets: build, package, clean

BUILD_DIR ?= build
SRC_DIR   ?= src

SRCS     := $(sort $(wildcard $(SRC_DIR)/*))
ARTIFACT := $(BUILD_DIR)/$(APP_NAME)-$(VERSION).txt
PACKAGE  := $(BUILD_DIR)/$(APP_NAME)-$(VERSION).tar.gz

.PHONY: build package clean

build: $(ARTIFACT) ## Compilar el módulo (artefacto en BUILD_DIR)

# El artefacto es un archivo real: si ningún fuente cambió, Make no lo rehace.
$(ARTIFACT): $(SRCS)
	$(if $^,,$(error [$(APP_NAME)] $(SRC_DIR)/ no tiene fuentes))
	@mkdir -p $(@D)
	@{ echo "app=$(APP_NAME)"; echo "version=$(VERSION)"; cat $^; } > $@
	@echo "[$(APP_NAME)] Compilando $(APP_NAME) $(VERSION)"

package: $(PACKAGE) ## Empaquetar el artefacto en un .tar.gz

$(PACKAGE): $(ARTIFACT)
	@tar -czf $@ -C $(<D) $(<F)
	@echo "[$(APP_NAME)] Empaquetado $@"

clean: ## Borrar BUILD_DIR
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD_DIR)'
	@echo "[$(APP_NAME)] Limpiando artefactos"
