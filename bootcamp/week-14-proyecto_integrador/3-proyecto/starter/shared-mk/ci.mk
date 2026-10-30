# shared-mk/ci.mk
.PHONY: ci lint

# Cada módulo de lenguaje define su LINT_CMD.
LINT_CMD ?=

# TODO: implementar lint (prerrequisito: deps): ejecuta $(LINT_CMD) e
#       imprime [$(APP_NAME)] Lint OK
lint: ## Verificar estilo del código

# TODO: implementar ci como dependencia de lint → test → build
# ci: lint test build
ci: ## Ejecutar pipeline CI del servicio
