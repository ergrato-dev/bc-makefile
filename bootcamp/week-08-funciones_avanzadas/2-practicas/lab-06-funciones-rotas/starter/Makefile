.PHONY: all demo clean help
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

demo: ## Demostrar el Makefile con los 4 bugs
	@echo "OBJS:     $(OBJS)"
	$(call deploy_info,8080,api)
	@echo "Git hash: $(GIT_HASH)"
	@echo "Reglas generadas para: $(MODULES)"

clean: ## Limpiar
	@rm -rf $(BUILD)/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
