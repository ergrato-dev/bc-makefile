# ============================================================
# Proyecto Semana 13 — Makefile de "notify" (heredado, SIN AUDITAR)
# ============================================================
# Este Makefile funciona... y tiene al menos diez problemas de seguridad,
# robustez o portabilidad. Tu trabajo: encontrarlos, documentarlos en
# AUDITORIA.md y corregirlos. Los TODO marcan dónde mirar, no qué escribir.
#
# Uso típico (así lo llama el CI):
#   make package VERSION=$TAG BRANCH=$RAMA
#   make deploy  DEPLOY_TOKEN=$TOKEN

# TODO 0: guarda de versión mínima de Make (MIN_MAKE_VERSION := 4.3) antes que
#         nada; con un mensaje que diga "Se requiere GNU Make >= ...".
#         Lab 05, paso 1.

# TODO 1: preámbulo estricto (Semana 03).

.PHONY: help install-tools lint package deploy clean check
.DEFAULT_GOAL := help

# --- Configuración ----------------------------------------------------------
APP        := notify
VERSION    ?= 0.1.0
BRANCH     ?= main
BUILD_DIR  ?= build
TOOLS_DIR  := $(BUILD_DIR)/tools
SRCS       := $(wildcard src/*.sh)
DEPLOY_URL ?= file://$(CURDIR)/$(BUILD_DIR)/remote/
TOOL_URL   ?= file://$(CURDIR)/vendor/install-fmt-tool.sh

# Marca de build: se crea al cargar el Makefile.
# TODO 2: ¿qué pasa con esta línea en `make help` o `make -n`? (Lab 01)
BUILD_STAMP := $(shell mkdir -p build && date +%s | tee build/.stamp)

# Secretos locales (DEPLOY_URL, DEPLOY_TOKEN).
# TODO 3: ¿qué hace Make con este archivo? ¿Y si alguien lo modifica? (Lab 01)
ENV_FILE ?= .env
-include $(ENV_FILE)

# Las herramientas necesitan las variables del Makefile.
# TODO 4: ¿cuáles llegan realmente a cada receta? (Lab 03, paso 1)
export

# --- Targets ----------------------------------------------------------------

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# TODO 5: descarga y ejecución en un solo paso. (Lab 03, paso 7)
install-tools: ## Instala fmt-tool
	curl -fsSL $(TOOL_URL) | PREFIX=$(TOOLS_DIR) sh

lint: install-tools ## Comprueba la sintaxis de src/ con fmt-tool
	$(TOOLS_DIR)/fmt-tool $(SRCS)

# TODO 6: VERSION y BRANCH vienen del CI (tags y nombres de rama). (Lab 02)
# TODO 7: package se rehace siempre; make -q nunca puede decir "al día". (Lab 04)
package: ## Empaqueta src/ en build/notify-VERSION.tar.gz
	mkdir -p $(BUILD_DIR)
	echo "version=$(VERSION)" > $(BUILD_DIR)/BUILDINFO
	echo "branch=$(BRANCH)" >> $(BUILD_DIR)/BUILDINFO
	echo "job=$(CI_JOB_ID)" >> $(BUILD_DIR)/BUILDINFO
	tar -czf $(BUILD_DIR)/$(APP)-$(VERSION).tar.gz src -C $(BUILD_DIR) BUILDINFO
	@echo "Paquete: $(BUILD_DIR)/$(APP)-$(VERSION).tar.gz ($$(stat -c %s $(BUILD_DIR)/$(APP)-$(VERSION).tar.gz) bytes)"

# TODO 8: ¿dónde queda visible el token? (make -n, ps, logs del CI) (Lab 03)
$(BUILD_DIR)/curl-auth.conf:
	mkdir -p $(BUILD_DIR)
	echo 'header = "Authorization: Bearer $(DEPLOY_TOKEN)"' > $@

deploy: package $(BUILD_DIR)/curl-auth.conf ## Sube el paquete a DEPLOY_URL
	mkdir -p $(BUILD_DIR)/remote
	curl -fsS -K $(BUILD_DIR)/curl-auth.conf -T $(BUILD_DIR)/$(APP)-$(VERSION).tar.gz $(DEPLOY_URL)
	@echo "Desplegado $(APP) $(VERSION) en $(DEPLOY_ENV)"

# TODO 9: ¿qué borra esto con BUILD_DIR= o BUILD_DIR=/? (Lab 02, paso 7)
clean: ## Borra los artefactos
	rm -rf $(BUILD_DIR)/*

# TODO 10: autoprueba del Makefile. (Lab 04, paso 4)
check: ## Autoprueba del Makefile
	@echo "TODO: implementa la autoprueba"
	@exit 1
