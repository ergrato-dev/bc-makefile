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

# --------------------------------------------------------------------------
# TODO 1 (paso 4): si SRCS está vacía, avisa con $(warning ...) que
#         "No hay fuentes en <SRC_DIR>/: <OUT> saldrá vacío". Make debe seguir.
# --------------------------------------------------------------------------

build: $(OUT) ## Generar el manual a partir de src/*.txt

# Esta regla tiene un bug que no da ningún error (paso 6).
$(OUT): $(SRC)
	@mkdir -p $(@D)
	@cat /dev/null $(SRCS) > $@
	@echo "[build] $@ <- $(words $(SRCS)) capítulos"

# --------------------------------------------------------------------------
# TODO 2 (paso 2): 'debug-vars' muestra con $(info ...) una línea por
#         variable, con el formato "NOMBRE        = valor":
#         APP_NAME, ENV, SRCS, OUT y MAKEFILE_LIST.
#         Escribe esas líneas en la receta; no las dejes en un comentario
#         con TAB: Make expande $(...) también ahí.
# --------------------------------------------------------------------------
debug-vars: ## Mostrar variables clave para diagnóstico
	@echo "Variables mostradas."

# --------------------------------------------------------------------------
# TODO 3 (paso 5): 'validate' se detiene con $(error ...) si APP_NAME está
#         vacía ("APP_NAME no puede estar vacía: make validate APP_NAME=<nombre>")
#         o si SRCS está vacía. Usa $(if $(VAR),,$(error ...)) como
#         línea de receta, no a nivel de archivo.
# --------------------------------------------------------------------------
validate: ## Validar que APP_NAME y SRCS no están vacías
	@echo "Validación OK"

# --------------------------------------------------------------------------
# TODO 4 (paso 7): 'debug-all' depende de debug-vars, validate y build.
# --------------------------------------------------------------------------
debug-all: ## Ejecutar todos los diagnósticos
	@echo "Diagnóstico completo."

clean: ## Borrar BUILD_DIR
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
