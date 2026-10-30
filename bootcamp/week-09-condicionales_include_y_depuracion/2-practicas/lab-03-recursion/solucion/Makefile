.PHONY: all clean test status build-parallel help
.DEFAULT_GOAL := help

MODULES := api worker frontend

all: ## Construir todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod build; \
	done

clean: ## Limpiar artefactos de todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod clean; \
	done

test: ## Ejecutar tests en todos los módulos
	@for mod in $(MODULES); do \
		$(MAKE) -C $$mod test; \
	done

status: ## Mostrar estado de todos los módulos
	@echo "Módulos registrados: $(MODULES)"
	@for mod in $(MODULES); do \
		echo "  ✓ $$mod — Makefile en $$mod/Makefile"; \
	done

build-parallel: ## Construir todos los módulos en paralelo
	@$(MAKE) -j$(words $(MODULES)) $(addprefix _build-,$(MODULES))

$(addprefix _build-,$(MODULES)):
	@$(MAKE) -C $(patsubst _build-%,%,$@) build

.PHONY: $(addprefix _build-,$(MODULES))

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
