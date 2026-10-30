SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: build validate debug-vars debug-all clean help
.DEFAULT_GOAL := help

APP_NAME  := manual
ENV       ?= development
SRC_DIR   ?= src
BUILD_DIR ?= build

SRCS := $(sort $(wildcard $(SRC_DIR)/*.txt))
OUT  := $(BUILD_DIR)/$(APP_NAME).txt

# Aviso al leer: Make sigue, pero deja constancia con archivo y línea.
ifeq ($(SRCS),)
  $(warning No hay fuentes en $(SRC_DIR)/: $(OUT) saldrá vacío)
endif

build: $(OUT) ## Generar el manual a partir de src/*.txt

$(OUT): $(SRCS)
	@mkdir -p $(@D)
	@cat /dev/null $^ > $@
	@echo "[build] $@ <- $(words $^) capítulos"

debug-vars: ## Mostrar variables clave para diagnóstico
	$(info APP_NAME      = $(APP_NAME))
	$(info ENV           = $(ENV))
	$(info SRCS          = $(SRCS))
	$(info OUT           = $(OUT))
	$(info MAKEFILE_LIST = $(MAKEFILE_LIST))
	@echo "Variables mostradas."

# El $(error) va dentro de la receta: solo se evalúa si se pide validate.
validate: ## Validar que APP_NAME y SRCS no están vacías
	$(if $(APP_NAME),,$(error APP_NAME no puede estar vacía: make validate APP_NAME=<nombre>))
	$(if $(SRCS),,$(error No hay fuentes en $(SRC_DIR)/))
	@echo "Validación OK"

debug-all: debug-vars validate build ## Ejecutar todos los diagnósticos
	@echo "Diagnóstico completo."

clean: ## Borrar BUILD_DIR
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
