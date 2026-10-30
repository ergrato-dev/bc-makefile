# shared-mk/ci.mk
.PHONY: ci lint

# TODO: implementar lint
# Imprimir: [$(APP_NAME)] Lint OK
lint: ## Verificar estilo del código

# TODO: implementar ci como dependencia de lint → test → build
# ci: lint test build
ci: ## Ejecutar pipeline CI del servicio
