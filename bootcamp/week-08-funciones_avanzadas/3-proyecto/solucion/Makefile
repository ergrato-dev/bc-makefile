SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info generate clean help
.DEFAULT_GOAL := help

CC       := gcc
CFLAGS   := -Wall -Wextra -std=c11
BUILD    := build
MANIFEST := $(BUILD)/manifest.mk

# --- Descubrimiento y metadatos (:= -> cada $(shell) corre una sola vez) ---
SERVICES   := $(notdir $(shell find services -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort))
BINS       := $(foreach svc,$(SERVICES),$(BUILD)/$(svc))
BUILD_DATE := $(shell date +%Y-%m-%dT%H:%M:%S)
GIT_HASH   := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)
OS_NAME    := $(shell uname -s)

# --- Plantilla por servicio ---
# Un '$' se expande en $(call), al generar la regla: $(1), $(BUILD), $(CC).
# '$$' llega a la receta como '$' y se expande al ejecutar: $$<, $$@.
define SERVICE_RULE
.PHONY: $(1) run-$(1)

$(1): $(BUILD)/$(1)

run-$(1): $(BUILD)/$(1)
	./$$<

$(BUILD)/$(1): services/$(1)/main.c | $(BUILD)
	$(CC) $(CFLAGS) $$< -o $$@
	@echo "Compilado: $$@"
endef

$(foreach svc,$(SERVICES),$(eval $(call SERVICE_RULE,$(svc))))

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

# $(file) escribe sin shell. Make expande toda la receta antes de ejecutarla:
# build/ tiene que existir ya (prerrequisito order-only), no basta un mkdir aquí.
generate: all | $(BUILD) ## Compilar y generar build/manifest.mk
	$(file >$(MANIFEST),# Generado automáticamente — no editar)
	$(file >>$(MANIFEST),BUILT_SERVICES := $(SERVICES))
	$(file >>$(MANIFEST),BUILD_DATE := $(BUILD_DATE))
	$(file >>$(MANIFEST),GIT_HASH := $(GIT_HASH))
	$(file >>$(MANIFEST),OS_NAME := $(OS_NAME))
	$(foreach svc,$(SERVICES),$(file >>$(MANIFEST),BIN_$(svc) := $(BUILD)/$(svc)))
	@echo "Manifest generado: $(MANIFEST)"
	@cat $(MANIFEST)

clean: ## Limpiar todo lo generado
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
