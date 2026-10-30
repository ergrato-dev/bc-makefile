# ============================================================
# Lab 06 — Alternativas a Make (SOLUCIÓN)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# El Makefile original, sin cambios: lo que se entrega son justfile,
# Taskfile.yml y DECISION.md.
#
# `make verify` comprueba la estructura de los tres archivos.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help build test release clean verify
.DEFAULT_GOAL := help

BUILD_DIR := build
SRCS      := $(sort $(wildcard src/*.txt))
MANUAL    := $(BUILD_DIR)/manual.txt
VERSION   ?=

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: $(MANUAL) ## Une src/*.txt en build/manual.txt (solo si cambió algo)

# Sin regla `$(BUILD_DIR):` para la carpeta: se llamaría `build`, igual que el
# target phony, y Make vería una dependencia circular. mkdir -p $(@D) basta.
$(MANUAL): $(SRCS)
	mkdir -p '$(@D)'
	cat $(SRCS) > '$@'

test: build ## Comprueba el manual
	grep -q 'Capítulo 1' '$(MANUAL)'

release: test ## Empaqueta: make release VERSION=1.2.3
	$(if $(VERSION),,$(error Falta VERSION: make release VERSION=1.2.3))
	[[ '$(subst ','\'',$(VERSION))' =~ ^[0-9]+[.][0-9]+[.][0-9]+$$ ]] || { echo "Versión inválida" >&2; exit 1; }
	tar -czf '$(BUILD_DIR)/manual-$(VERSION).tar.gz' -C '$(BUILD_DIR)' manual.txt

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

# --- Comprobación de la traducción (no la modifiques) -------------------------
# Revisa la estructura con grep: no ejecuta just ni task, no hace falta tenerlos.
define need
@grep -qE $(2) $(1) || { echo "FALTA en $(1): $(3)"; exit 1; }
endef

verify: ## Comprueba la estructura de justfile, Taskfile.yml y DECISION.md
	@test -f justfile || { echo "FALTA justfile (paso 2)"; exit 1; }
	$(call need,justfile,'^set shell',set shell con bash -euo pipefail)
	$(call need,justfile,'^build:',receta build)
	$(call need,justfile,'^test: *build',receta test que depende de build)
	$(call need,justfile,'^release +version',receta release con parámetro version)
	$(call need,justfile,'quote[(]version[)]',quote(version) para citar el argumento)
	@test -f Taskfile.yml || { echo "FALTA Taskfile.yml (paso 3)"; exit 1; }
	$(call need,Taskfile.yml,"^version: *'3'",version: 3)
	$(call need,Taskfile.yml,'^ +sources:',sources: en build)
	$(call need,Taskfile.yml,'^ +generates:',generates: en build)
	$(call need,Taskfile.yml,'^ +requires:',requires: vars: [VERSION] en release)
	$(call need,Taskfile.yml,'[$$]VERSION',VERSION leída como variable de entorno)
	@! grep -q TODO DECISION.md || { echo "DECISION.md todavía tiene TODO (paso 5)"; exit 1; }
	@test "$$(grep -cE '^[|] *[1-6] *[|]' DECISION.md)" -ge 6 || { echo "DECISION.md: faltan escenarios"; exit 1; }
	@echo "verify: OK"
