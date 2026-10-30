SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all demo dirs report clean help
.DEFAULT_GOAL := help

ENVS    := dev staging prod
REGIONS := us-east eu-west ap-south

DEPLOY_DIRS   := $(foreach env,$(ENVS),deploy/$(env))
ENV_FLAGS     := $(foreach env,$(ENVS),-DENV_$(env))
DEPLOY_MATRIX := $(foreach region,$(REGIONS),$(foreach env,$(ENVS),$(region)-$(env)))

demo: ## Imprimir todas las variables generadas
	@echo "DEPLOY_DIRS:   $(DEPLOY_DIRS)"
	@echo "ENV_FLAGS:     $(ENV_FLAGS)"
	@echo "DEPLOY_MATRIX: $(DEPLOY_MATRIX)"
	@echo "Combinaciones: $(words $(DEPLOY_MATRIX))"

dirs: ## Crear estructura de directorios de deploy
	@$(foreach dir,$(DEPLOY_DIRS),mkdir -p $(dir);)
	@echo "Directorios creados: $(DEPLOY_DIRS)"

report: ## Imprimir reporte de entornos
	@echo "=== Reporte de entornos ==="
	@$(foreach env,$(ENVS),echo "  - $(env) → deploy/$(env)";)
	@echo "Total: $(words $(ENVS)) entornos"

clean: ## Eliminar directorios de deploy
	@rm -rf deploy/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
