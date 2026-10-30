# ============================================================
# Lab 06 — Variables rotas (SOLUCIÓN)
# ============================================================
# Correcciones aplicadas:
#   Bug 1: mover REGISTRY antes de IMAGE, o cambiar IMAGE a =
#   Bug 2: usar += en lugar de = para acumular FLAGS
#   Bug 3: mover las ?= antes de la := que las usa, o cambiar DB_URL a =
#   Bug 4: usar BASE como variable separada y no referenciar VERSION a sí misma
# ============================================================

.PHONY: check-image check-flags check-url check-version diagnostico help

.DEFAULT_GOAL := help

# ── Fix 1: REGISTRY se define ANTES de IMAGE ─────────────────
REGISTRY := registry.local
IMAGE    := $(REGISTRY)/myapp:latest

# ── Fix 2: usar += para acumular FLAGS ───────────────────────
FLAGS    := -Wall
FLAGS    += -Wextra
FLAGS    += -O2

# ── Fix 3: ?= antes de la := que las usa ─────────────────────
DB_HOST  ?= localhost
DB_NAME  ?= myapp_dev
DB_URL   := postgres://$(DB_HOST):5432/$(DB_NAME)

# ── Fix 4: variable base separada, no self-reference ─────────
BASE     := v1.0
VERSION  := $(BASE)-rc1

## check-image: verifica que IMAGE sea registry.local/myapp:latest
check-image:
	@echo "IMAGE: $(IMAGE)"

## check-flags: verifica que FLAGS tenga los tres flags
check-flags:
	@echo "FLAGS: $(FLAGS)"

## check-url: verifica que DB_URL sea la URL completa
check-url:
	@echo "DB_URL: $(DB_URL)"

## check-version: verifica que VERSION sea v1.0-rc1
check-version:
	@echo "VERSION: $(VERSION)"

## diagnostico: muestra el sabor de cada variable sin expandirla
diagnostico:
	@echo "IMAGE:   $(flavor IMAGE)"
	@echo "FLAGS:   $(flavor FLAGS)"
	@echo "DB_URL:  $(flavor DB_URL)"
	@echo "VERSION: $(flavor VERSION)"
	@echo "DB_HOST: $(flavor DB_HOST), origen $(origin DB_HOST)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [check-image|check-flags|check-url|check-version]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
