# ============================================================
# Lab 01 — Parse-time vs run-time (SOLUCIÓN)
# ============================================================
# Regla: al parsear solo se lee, y poco. Todo lo que escribe, tarda o llama
# a la red va en una receta, como shell.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help build publish clean
.DEFAULT_GOAL := help

OUT_DIR   := out
CACHE_DIR := .cache

# .env se valida ANTES de incluirlo: solo claves conocidas y valores simples.
# Si hay líneas malas se dicen sus números, nunca su contenido.
ENV_FILE ?= .env
ifneq ($(wildcard $(ENV_FILE)),)
  ENV_BAD := $(shell grep -nvE '^(#.*|SITE_TITLE=[A-Za-z0-9_./:@+-]*)?$$' '$(ENV_FILE)' | cut -d: -f1)
  ifneq ($(ENV_BAD),)
    $(error $(ENV_FILE): líneas no permitidas: $(ENV_BAD). Formato: SITE_TITLE=valor)
  endif
  include $(ENV_FILE)
endif

SITE_TITLE ?= Docs

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Las carpetas se crean cuando un target las necesita, no al parsear.
$(OUT_DIR) $(CACHE_DIR):
	mkdir -p '$@'

# La consulta lenta es shell dentro de la receta: make -n la muestra, no la ejecuta.
build: | $(OUT_DIR) ## Genera out/index.html
	latest=$$(sleep 2; echo 1.4.2); \
	echo "<h1>$(SITE_TITLE) $$latest</h1>" > '$(OUT_DIR)/index.html'

# Sin +: el + es para líneas que lanzan $(MAKE), y esta no lo hace.
publish: build | $(CACHE_DIR) ## Publica out/ en .cache/published
	touch '$(CACHE_DIR)/last-publish'
	cp -r '$(OUT_DIR)' '$(CACHE_DIR)/published'
	@echo "Publicado $(SITE_TITLE)"

clean: ## Borra out/ y .cache/
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	$(if $(CACHE_DIR),,$(error CACHE_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(OUT_DIR)' '$(CACHE_DIR)'
