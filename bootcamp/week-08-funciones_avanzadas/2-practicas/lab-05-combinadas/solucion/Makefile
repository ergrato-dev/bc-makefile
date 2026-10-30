SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all demo info clean help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build

PLUGIN_DIRS := $(shell find plugins -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
PLUGINS     := $(notdir $(PLUGIN_DIRS))
ALL_OBJS    := $(foreach p,$(PLUGINS),$(BUILD)/$(p).o)

define PLUGIN_RULE
.PHONY: plugin-$(1)
plugin-$(1): $(BUILD)/$(1).o

$(BUILD)/$(1).o: plugins/$(1)/plugin.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $$< -o $$@
endef

$(foreach p,$(PLUGINS),$(eval $(call PLUGIN_RULE,$(p))))

info: ## Mostrar plugins descubiertos
	@echo "Directorios: $(PLUGIN_DIRS)"
	@echo "Plugins:     $(PLUGINS)"
	@echo "Objetos:     $(ALL_OBJS)"
	@echo "Total:       $(words $(PLUGINS)) plugins"

all: $(ALL_OBJS) ## Compilar todos los plugins
	@echo "Todos los plugins compilados: $(PLUGINS)"

demo: info ## Demostrar el build system

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
