# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all info generate clean help
.DEFAULT_GOAL := help

CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
BUILD    := build
MANIFEST := $(BUILD)/manifest.mk

# TODO 1: Auto-descubre servicios con $(shell find ...)
# y extrae solo los nombres con $(notdir ...)
# Pista: $(notdir $(shell find services -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort))
SERVICES :=

# TODO 2: Genera las rutas de los binarios: build/api build/worker ...
# Pista: $(foreach svc,$(SERVICES),$(BUILD)/$(svc))
BINS :=

# TODO 3: Captura metadatos del sistema
BUILD_DATE :=
GIT_HASH   :=
OS_NAME    :=

# TODO 4: Define la plantilla SERVICE_RULE que genera, para el servicio $(1):
# - Los targets phony '$(1)' y 'run-$(1)'
# - $(1) depende de $(BUILD)/$(1)
# - run-$(1) depende de $(BUILD)/$(1) y lo ejecuta: ./$$<
# - La regla de compilación: $(BUILD)/$(1): services/$(1)/main.c | $(BUILD)
# Recuerda usar $$< y $$@ en las recetas (ver 3-proyecto/README.md)
# define SERVICE_RULE
# endef

# TODO 5: Instancia SERVICE_RULE para cada servicio descubierto
# Pista: $(foreach svc,$(SERVICES),$(eval $(call SERVICE_RULE,$(svc))))

$(BUILD):
	@mkdir -p $@

all: $(BINS) ## Compilar todos los servicios
	@echo "=== Build completo ==="
	@$(foreach svc,$(SERVICES),echo "  $(svc): $(BUILD)/$(svc)";)

info: ## Mostrar servicios descubiertos y metadatos
	@echo "=== Orquestador de Microservicios ==="
	@echo "Servicios:  $(SERVICES)"
	@echo "Binarios:   $(BINS)"
	@echo "Total:      $(words $(SERVICES)) servicios"
	@echo "---"
	@echo "Git:        $(GIT_HASH)"
	@echo "Fecha:      $(BUILD_DATE)"
	@echo "OS:         $(OS_NAME)"

# TODO 6: escribe $(MANIFEST) con $(file) (sin printf ni echo), una línea por variable:
#   BUILT_SERVICES := ..., BUILD_DATE := ..., GIT_HASH := ..., OS_NAME := ...
#   y una línea BIN_<servicio> := build/<servicio> por servicio ($(foreach) + $(file >>...)).
# Pista: la primera escritura con $(file >...), el resto con $(file >>...).
generate: all | $(BUILD) ## Compilar y generar build/manifest.mk
	@echo "Manifest generado: $(MANIFEST)"

# TODO 7: en 'clean', guarda + borrado seguro (semana 03). Receta:
#   $(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
#   @rm -rf -- '$(BUILD)'
clean: ## Limpiar todo lo generado
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
