# ============================================================
# packages/package.mk — reglas comunes a todos los paquetes
# Cada packages/<nombre>/Makefile define PKG (y DEPS si consume
# otros paquetes) e incluye este archivo. No necesitas tocarlo.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: build clean help
.DEFAULT_GOAL := help

# --- Configuración (todo se puede pasar desde la línea de comandos) ---
VERSION  := 1.0
DIST_DIR := dist
DEPS     ?=
DELAY    ?= 1
FAIL     ?=
TRACE    ?= /dev/null

ARTIFACT  := $(DIST_DIR)/$(PKG).txt
DEP_FILES := $(foreach d,$(DEPS),../$(d)/$(DIST_DIR)/$(d).txt)

build: $(ARTIFACT) ## Construye el paquete

# Simula una compilación lenta (DELAY segundos). Escribe "start"/"end" en
# TRACE para poder contar cuántos paquetes se construyen a la vez.
# FAIL=<paquete> hace fallar ese paquete a propósito.
$(ARTIFACT): $(DEP_FILES)
	@echo "start $(PKG)" >> '$(TRACE)'
	@echo "[$(PKG)] inicio"
	@sleep $(DELAY)
	@if [ '$(FAIL)' = '$(PKG)' ]; then echo "end $(PKG)" >> '$(TRACE)'; echo "[$(PKG)] FALLÓ (FAIL=$(PKG))"; exit 1; fi
	@mkdir -p $(@D)
	@{ echo "$(PKG) $(VERSION)"; $(foreach f,$(DEP_FILES),sed 's/^/  /' $(f);) } > $@
	@echo "end $(PKG)" >> '$(TRACE)'
	@echo "[$(PKG)] fin"

# Los paquetes de los que depende este los construye el Makefile raíz.
# Si llegas aquí, el raíz no declaró la dependencia (o -j la adelantó).
ifneq ($(DEP_FILES),)
$(DEP_FILES):
	@echo "[$(PKG)] falta $@: el Makefile raíz debe construir antes ese paquete" >&2
	@exit 1
endif

clean: ## Borra dist/
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(DIST_DIR)'
	@echo "[$(PKG)] clean"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles en $(PKG):"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
