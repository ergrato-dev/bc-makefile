# ============================================================
# Monorepo — build paralelo y recursión segura (SOLUCIÓN)
# Semana 10: Paralelismo y recursión
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# --- Paralelismo ---------------------------------------------
# Con -j, la salida de cada target sale en bloque. OUTPUT_SYNC se
# define antes de MAKEFLAGS: Make 4.4 lee MAKEFLAGS en cuanto cambia.
# make -j4 all OUTPUT_SYNC=none muestra la salida entrelazada.
OUTPUT_SYNC ?= target
MAKEFLAGS   += --output-sync=$(OUTPUT_SYNC)

# --- Paquetes ------------------------------------------------
PKG_DIR  := packages
PACKAGES := core util docs app
GOALS    := build clean

# packages/core/build, packages/core/clean, packages/util/build...
# Cada uno es un nodo del grafo: un fallo detiene el build, -k sigue
# con los independientes y -j los ejecuta en paralelo.
PKG_PATHS   := $(addprefix $(PKG_DIR)/,$(PACKAGES))
PKG_TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(PKG_PATHS)))

.PHONY: all clean rebuild help $(PKG_TARGETS)
.DEFAULT_GOAL := help

# --- Grafo entre paquetes -------------------------------------
all: $(addsuffix /build,$(PKG_PATHS)) ## Construye todos los paquetes

clean: $(addsuffix /clean,$(PKG_PATHS)) ## Borra el dist/ de cada paquete

# app consume los artefactos de core y util: sin esta línea, -j
# lanza app antes de que existan.
$(PKG_DIR)/app/build: $(PKG_DIR)/core/build $(PKG_DIR)/util/build

# --- Recursión -----------------------------------------------
# $(MAKE) (no make): mismo binario, mismos flags y jobserver
# compartido; además se ejecuta con -n. En packages/core/build,
# $(@D) es packages/core y $(@F) es build.
$(PKG_TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F)

# clean y all en el mismo grafo se pisan con -j. Dos sub-makes en
# secuencia lo evitan en Make 4.3; con 4.4 basta: rebuild: clean .WAIT all
rebuild: ## Borra y reconstruye todo (seguro con -j)
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory all

# --- Utilidades ----------------------------------------------
help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo "Por paquete: make $(PKG_DIR)/<paquete>/{build,clean}  (paquetes: $(PACKAGES))"
