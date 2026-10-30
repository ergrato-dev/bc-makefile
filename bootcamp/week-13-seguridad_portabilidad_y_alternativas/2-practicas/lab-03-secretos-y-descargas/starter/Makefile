# ============================================================
# Lab 03 — Secretos sin fugas y descargas verificadas (STARTER)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# Sube un paquete con un token (API_TOKEN) e instala una herramienta.
# El "servidor" es una carpeta local (build/remote/): no hace falta red.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help lint spy upload install-tool clean
.DEFAULT_GOAL := help

APP_NAME  := demo
BUILD_DIR := build
PKG       := $(BUILD_DIR)/$(APP_NAME).tar.gz
AUTH_FILE := $(BUILD_DIR)/auth.conf
TOOL_URL  ?= file://$(CURDIR)/vendor/install-hello.sh

# Secretos locales: una línea API_TOKEN=valor. OJO: include parsea .env como
# Makefile ($(shell) se ejecuta); aquí no se valida para centrarse en las
# fugas, pero en un proyecto real va la lista blanca del lab 01.
-include .env
API_TOKEN ?=

# TODO (pasos 1 y 2): ¿qué variables llegan a cada receta?
export

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Simula un linter de terceros: dice si puede leer el token.
lint: ## Linter de terceros (¿ve el token?)
	@if [[ -n "$${API_TOKEN:-}" ]]; then echo "lint: veo API_TOKEN"; else echo "lint: no veo API_TOKEN"; fi

# TODO (paso 3): imprime el argv del bash de esta línea, tal como lo vería `ps`.
spy: ## Muestra lo que `ps` vería de una receta que usa el token
	@echo "token=$(API_TOKEN)" >/dev/null; ps -o args= -p $$$$; true

$(PKG):
	mkdir -p $(BUILD_DIR)
	tar -czf $@ Makefile

# TODO (paso 5): ¿con qué permisos nace este archivo?
$(AUTH_FILE):
	mkdir -p $(BUILD_DIR)
	echo 'header = "Authorization: Bearer $(API_TOKEN)"' > $@

# TODO (pasos 4 y 6): ¿qué imprime make -n upload? ¿y el log de esta herramienta?
upload: $(PKG) $(AUTH_FILE) ## Sube el paquete al "servidor"
	mkdir -p $(BUILD_DIR)/remote
	@printf 'curl-debug: usando token %s\n' "$(API_TOKEN)"
	curl -fsS -K $(AUTH_FILE) -T $(PKG) file://$(CURDIR)/$(BUILD_DIR)/remote/
	@echo "Subido $(PKG)"

# TODO (paso 7): descarga y ejecución en un solo paso.
install-tool: ## Instala hello en build/tools
	curl -fsSL $(TOOL_URL) | PREFIX=$(BUILD_DIR)/tools sh

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
