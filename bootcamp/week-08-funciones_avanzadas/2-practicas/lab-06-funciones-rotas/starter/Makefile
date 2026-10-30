.PHONY: all demo list clean help
.DEFAULT_GOAL := help

BUILD   := build
MODULES := auth logger config
CC      := gcc

# BUG 1: La variable de iteración es 'm' pero dentro del texto se usa '$(mod)'
# Síntoma: OBJS queda vacío
OBJS := $(foreach m,$(MODULES),$(BUILD)/$(mod).o)

# BUG 2: Los argumentos de $(call) están invertidos al llamar a deploy_info
# Síntoma: el puerto aparece donde debería el nombre y viceversa
define deploy_info
	@echo "Desplegando $1 en puerto $2"
endef

# Llamada con argumentos invertidos:
show-deploy:
	$(call deploy_info,8080,api)

# BUG 3: Falta $$ en $$< y $$@ dentro del define — se expanden a vacío en parse
# Síntoma: la receta generada tiene: "gcc -c  -o " (sin archivos)
define COMPILE_RULE
$(BUILD)/$(1).o: src/$(1).c
	$(CC) -c $< -o $@
endef

$(foreach m,$(MODULES),$(eval $(call COMPILE_RULE,$(m))))

# BUG 4: git rev-parse sin --short y sin fallback
# Síntoma: vacío si no hay repo git, o hash completo de 40 chars
GIT_HASH := $(shell git rev-parse HEAD)

# BUG 5: el foreach de la receta no separa los comandos con ';'
# Síntoma: make list imprime una sola línea en lugar de tres
list: ## Listar módulos, uno por línea
	@$(foreach m,$(MODULES),echo "  - $(m)")

# BUG 6: BUILD_ID usa '=' con $(shell)
# Síntoma: el artefacto y el manifest de un mismo build muestran IDs distintos
BUILD_ID = $(shell date +%s%N)

demo: ## Demostrar el Makefile con los 6 bugs
	@echo "OBJS:     $(OBJS)"
	$(call deploy_info,8080,api)
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
