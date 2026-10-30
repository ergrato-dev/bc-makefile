# ============================================================
# Lab 06 — Variables rotas (Makefile con 4 bugs)
# Semana 02: Variables y Expansión en Make
# ============================================================
# Este Makefile carga sin errores de sintaxis pero tiene 4 bugs.
# Ejecuta cada target, observa el output incorrecto,
# encuentra cada BUG y corrígelo.
# ============================================================

.PHONY: check-image check-flags check-url check-version diagnostico help

.DEFAULT_GOAL := help

# ── Bug 1: forward reference con := ──────────────────────────
# BUG: IMAGE se construye con := ANTES de que REGISTRY esté definido
IMAGE    := $(REGISTRY)/myapp:latest
REGISTRY := registry.local
# Resultado actual:  IMAGE = /myapp:latest     (REGISTRY vacío)
# Resultado esperado: IMAGE = registry.local/myapp:latest

# ── Bug 2: append con = en lugar de += ───────────────────────
FLAGS    := -Wall
# BUG: esta línea sobreescribe FLAGS en lugar de acumular
FLAGS     = -Wextra
# BUG: esta línea también sobreescribe en lugar de acumular
FLAGS     = -O2
# Resultado actual:   FLAGS = -O2              (solo el último)
# Resultado esperado: FLAGS = -Wall -Wextra -O2

# ── Bug 3: ?= después de := que depende de ella ──────────────
# BUG: DB_URL usa := y se construye ANTES de que DB_NAME esté definido con ?=
DB_URL   := postgres://$(DB_HOST):5432/$(DB_NAME)
DB_HOST  ?= localhost
DB_NAME  ?= myapp_dev
# Resultado actual:   DB_URL = postgres://:5432/    (vars vacías)
# Resultado esperado: DB_URL = postgres://localhost:5432/myapp_dev

# ── Bug 4: self-reference con = ──────────────────────────────
# BUG: VERSION con = se referencia a sí misma → recursión infinita
BASE     := v1.0
VERSION   = $(VERSION)-rc1
# Resultado actual:   error de recursión infinita al usar VERSION
# Resultado esperado: VERSION = v1.0-rc1

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
