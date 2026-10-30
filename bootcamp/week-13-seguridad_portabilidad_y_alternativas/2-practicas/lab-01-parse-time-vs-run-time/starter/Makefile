# ============================================================
# Lab 01 — Parse-time vs run-time (STARTER)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# Genera una mini web de documentación en out/ y la "publica" en .cache/.
# Funciona, pero ejecuta cosas cuando nadie se lo pide.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help build publish clean
.DEFAULT_GOAL := help

OUT_DIR := out

# TODO 1 (paso 1): esta consulta "de red" (simulada con sleep) se ejecuta
# al cargar el Makefile. Mídelo con: time make help
LATEST := $(shell sleep 2; echo 1.4.2)

# TODO 2 (paso 1): esta línea crea una carpeta... ¿cuándo?
CACHE := $(shell mkdir -p .cache && echo .cache)

# TODO 3 (pasos 5 y 6): include parsea el archivo como Makefile.
ENV_FILE ?= .env
-include $(ENV_FILE)

SITE_TITLE ?= Docs

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: ## Genera out/index.html
	mkdir -p $(OUT_DIR)
	echo "<h1>$(SITE_TITLE) $(LATEST)</h1>" > $(OUT_DIR)/index.html

# TODO 4 (pasos 2 y 4): ¿qué hace el + con make -n?
publish: build ## Publica out/ en .cache/published
	+touch $(CACHE)/last-publish
	cp -r $(OUT_DIR) $(CACHE)/published
	@echo "Publicado $(SITE_TITLE) $(LATEST)"

clean: ## Borra out/ y .cache/
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(OUT_DIR)' .cache
