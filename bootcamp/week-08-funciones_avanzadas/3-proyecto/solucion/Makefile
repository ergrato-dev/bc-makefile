.PHONY: all info generate clean help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build

SERVICES   := $(notdir $(shell find services -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort))
BINS       := $(foreach svc,$(SERVICES),$(BUILD)/$(svc))
BUILD_DATE := $(shell date +%Y-%m-%dT%H:%M:%S)
GIT_HASH   := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)
OS_NAME    := $(shell uname -s)

define SERVICE_RULE
.PHONY: $(1)

$(1): $(BUILD)/$(1)

$(BUILD)/$(1): services/$(1)/main.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $$< -o $$@
	@echo "Compilado: $$@"
endef

$(foreach svc,$(SERVICES),$(eval $(call SERVICE_RULE,$(svc))))

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

generate: all ## Compilar y generar build/manifest.mk
	@mkdir -p $(BUILD)
	@printf "BUILT_SERVICES := %s\nBUILD_DATE := %s\nGIT_HASH := %s\nOS_NAME := %s\n" \
		"$(SERVICES)" "$(BUILD_DATE)" "$(GIT_HASH)" "$(OS_NAME)" \
		> $(BUILD)/manifest.mk
	@echo "# Generado automáticamente — no editar" >> $(BUILD)/manifest.mk
	@echo "Manifest generado: $(BUILD)/manifest.mk"
	@cat $(BUILD)/manifest.mk

clean: ## Limpiar todo lo generado
	@rm -rf $(BUILD)/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
