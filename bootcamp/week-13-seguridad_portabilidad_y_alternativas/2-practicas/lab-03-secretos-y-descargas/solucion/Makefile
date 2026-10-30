# ============================================================
# Lab 03 — Secretos sin fugas y descargas verificadas (SOLUCIÓN)
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help lint spy upload install-tool clean
.DEFAULT_GOAL := help

APP_NAME   := demo
BUILD_DIR  := build
PKG        := $(BUILD_DIR)/$(APP_NAME).tar.gz
AUTH_FILE  := $(BUILD_DIR)/auth.conf
TOOLS_DIR  := $(BUILD_DIR)/tools
REMOTE_DIR := $(BUILD_DIR)/remote
TOOL_URL   ?= file://$(CURDIR)/vendor/install-hello.sh
# Se fija junto a la versión: si el instalador cambia, el build falla.
TOOL_SHA256 := 83b183b5569f9ce18cf2c9e28a9ced0b9572d935321395851804a26de08552a5
# sha256sum (GNU) o shasum -a 256 (macOS). '=' perezoso: solo si una receta lo usa.
SHA256SUM    = $(if $(shell command -v sha256sum 2>/dev/null),sha256sum,shasum -a 256)

# OJO: include parsea .env como Makefile ($(shell) se ejecuta). Aquí no se
# valida para centrarse en las fugas; en un proyecto real, lista blanca del lab 01.
-include .env
API_TOKEN ?=

# FIX pasos 1 y 2: nada de `export` a secas. unexport quita el token del
# entorno de TODAS las recetas, aunque venga del entorno o de la línea de
# comandos; solo la receta que escribe las credenciales lo recibe.
unexport API_TOKEN
$(AUTH_FILE): export API_TOKEN := $(API_TOKEN)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

lint: ## Linter de terceros (¿ve el token?)
	@if [[ -n "$${API_TOKEN:-}" ]]; then echo "lint: veo API_TOKEN"; else echo "lint: no veo API_TOKEN"; fi

# FIX paso 3: "$$API_TOKEN" lo expande bash; el argv solo contiene el nombre.
spy: export API_TOKEN := $(API_TOKEN)
spy: ## Muestra lo que `ps` vería de una receta que usa el token
	@echo "token=$$API_TOKEN" >/dev/null; ps -o args= -p $$$$; true

$(BUILD_DIR) $(REMOTE_DIR):
	mkdir -p '$@'

$(PKG): | $(BUILD_DIR)
	tar -czf '$@' Makefile

# FIX paso 5: umask 077 en la misma línea que escribe: el archivo nace 600.
$(AUTH_FILE): | $(BUILD_DIR)
	$(if $(API_TOKEN),,$(error API_TOKEN vacía: defínela en .env o en el entorno))
	umask 077; printf 'header = "Authorization: Bearer %s"\n' "$$API_TOKEN" > '$@'

# FIX paso 4: ninguna línea contiene el valor. FIX paso 6: la salida de la
# herramienta se filtra con bash puro (${out//...}); con sed, el token iría
# en el argv de sed y `ps` lo vería.
upload: export API_TOKEN := $(API_TOKEN)
upload: $(PKG) $(AUTH_FILE) | $(REMOTE_DIR) ## Sube el paquete al "servidor"
	out=$$(printf 'curl-debug: usando token %s\n' "$$API_TOKEN"); \
	printf '%s\n' "$${out//"$$API_TOKEN"/****}"
	curl -fsS -K '$(AUTH_FILE)' -T '$(PKG)' 'file://$(CURDIR)/$(REMOTE_DIR)/'
	@echo "Subido $(PKG)"

# FIX paso 7: descargar a un archivo, verificar el SHA-256 y solo entonces ejecutar.
install-tool: $(TOOLS_DIR)/hello ## Instala hello en build/tools (verificado)

$(TOOLS_DIR)/hello: export TOOL_URL := $(TOOL_URL)
$(TOOLS_DIR)/hello: | $(BUILD_DIR)
	curl -fsSL -o '$(BUILD_DIR)/install-hello.sh' "$$TOOL_URL"
	echo '$(TOOL_SHA256)  $(BUILD_DIR)/install-hello.sh' | $(SHA256SUM) -c - >/dev/null \
		|| { rm -f -- '$(BUILD_DIR)/install-hello.sh'; echo "SHA-256 incorrecto: el instalador no se ejecuta" >&2; exit 1; }
	PREFIX='$(TOOLS_DIR)' sh '$(BUILD_DIR)/install-hello.sh'

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
