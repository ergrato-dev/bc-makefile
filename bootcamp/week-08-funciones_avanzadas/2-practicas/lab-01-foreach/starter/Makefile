.PHONY: all demo dirs report clean help
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

dirs: ## Crear estructura de directorios de deploy
	# TODO 4: Usa $(foreach) DENTRO de la receta para crear cada directorio
	# Pista: @$(foreach dir,$(DEPLOY_DIRS),mkdir -p $(dir);)
	@echo "Directorios creados: $(DEPLOY_DIRS)"

report: ## Imprimir reporte de entornos
	@echo "=== Reporte de entornos ==="
	# TODO 5: Usa $(foreach) en la receta para imprimir cada entorno
	# Formato: "  - dev → deploy/dev"
	@echo "Total: $(words $(ENVS)) entornos"

clean: ## Eliminar directorios de deploy
	@rm -rf deploy/
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
