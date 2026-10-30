.PHONY: all demo info clean help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11
BUILD  := build

# TODO 1: Usa $(shell) para auto-descubrir directorios de plugins
# Pista: find plugins -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort
PLUGIN_DIRS :=

# TODO 2: Extrae solo los nombres de plugin (sin la ruta)
# Pista: $(notdir $(PLUGIN_DIRS))
PLUGINS :=

# TODO 3: Genera la lista de objetos build/<nombre>.o para cada plugin
# Pista: $(foreach p,$(PLUGINS),$(BUILD)/$(p).o)
ALL_OBJS :=

# TODO 4: Define la plantilla PLUGIN_RULE que genera:
# - La regla de compilación: $(BUILD)/$(1).o: plugins/$(1)/plugin.c
# - La receta: $(CC) $(CFLAGS) -c $$< -o $$@
# Recuerda: usa $$< y $$@ (doble dólar) para variables automáticas
# define PLUGIN_RULE
# endef

# TODO 5: Instancia PLUGIN_RULE para cada plugin descubierto
# Pista: $(foreach p,$(PLUGINS),$(eval $(call PLUGIN_RULE,$(p))))

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
