SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all demo list clean help
.DEFAULT_GOAL := help

BUILD   := build
MODULES := auth logger config
CC      := gcc

# FIX 1: Variable de iteración 'm' coincide con $(m) usado en el texto
OBJS := $(foreach m,$(MODULES),$(BUILD)/$(m).o)

# FIX 2: Argumentos en orden correcto — $1=servicio, $2=puerto
define deploy_info
	@echo "Desplegando $1 en puerto $2"
endef

# FIX 3: $$< y $$@ con doble dólar para sobrevivir la expansión de $(call)
define COMPILE_RULE
$(BUILD)/$(1).o: src/$(1).c
	$(CC) -c $$< -o $$@
endef

$(foreach m,$(MODULES),$(eval $(call COMPILE_RULE,$(m))))

# FIX 4: --short para hash corto y fallback para directorios sin git
GIT_HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)

# FIX 5: cada iteración termina en ';' y el foreach produce tres comandos
list: ## Listar módulos, uno por línea
	@$(foreach m,$(MODULES),echo "  - $(m)";)

# FIX 6: ':=' ejecuta $(shell) una sola vez, al leer el Makefile
BUILD_ID := $(shell date +%s%N)

demo: ## Demostrar el Makefile corregido
	@echo "OBJS:     $(OBJS)"
	$(call deploy_info,api,8080)
	@echo "Git hash: $(GIT_HASH)"
	@echo "Reglas generadas para: $(MODULES)"
	@echo "Artefacto: app-$(BUILD_ID).tar"
	@echo "Manifest:  app-$(BUILD_ID).tar"

clean: ## Limpiar
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
