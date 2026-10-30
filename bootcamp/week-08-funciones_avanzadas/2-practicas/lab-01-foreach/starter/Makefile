.PHONY: all demo dirs report configs clean help
.DEFAULT_GOAL := help

ENVS    := dev staging prod
REGIONS := us-east eu-west ap-south

# TODO 1: Usa $(foreach) para generar DEPLOY_DIRS a partir de ENVS
# Formato esperado: deploy/dev deploy/staging deploy/prod
DEPLOY_DIRS :=

# TODO 2: Usa $(foreach) para generar ENV_FLAGS a partir de ENVS
# Formato esperado: -DENV_dev -DENV_staging -DENV_prod
ENV_FLAGS :=

# TODO 3: Usa $(foreach) anidado para generar todas las combinaciones REGION-ENV
# Pista: $(foreach region,$(REGIONS),$(foreach env,$(ENVS),$(region)-$(env)))
# Formato esperado: us-east-dev us-east-staging us-east-prod eu-west-dev ...
DEPLOY_MATRIX :=

demo: ## Imprimir todas las variables generadas
	@echo "DEPLOY_DIRS:   $(DEPLOY_DIRS)"
	@echo "ENV_FLAGS:     $(ENV_FLAGS)"
	@echo "DEPLOY_MATRIX: $(DEPLOY_MATRIX)"
	@echo "Combinaciones: $(words $(DEPLOY_MATRIX))"

# TODO 4: Usa $(foreach) DENTRO de la receta para crear cada directorio
# Pista: @$(foreach dir,$(DEPLOY_DIRS),mkdir -p $(dir);)
dirs: ## Crear estructura de directorios de deploy
	@echo "Directorios creados: $(DEPLOY_DIRS)"

# TODO 5: Usa $(foreach) en la receta para imprimir cada entorno
# Formato: "  - dev → deploy/dev"
report: ## Imprimir reporte de entornos
	@echo "=== Reporte de entornos ==="
	@echo "Total: $(words $(ENVS)) entornos"

# TODO 6: Usa $(foreach) en la receta para crear deploy/<env>/config.env
# con el contenido ENV=<env>, para cada entorno. Cada iteración termina en ';'.
# Pista: mkdir -p deploy/$(env) && echo "ENV=$(env)" > deploy/$(env)/config.env;
configs: ## Crear deploy/<env>/config.env para cada entorno
	@echo "Configs: $(foreach env,$(ENVS),deploy/$(env)/config.env)"

clean: ## Eliminar directorios de deploy
	@rm -rf deploy/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
