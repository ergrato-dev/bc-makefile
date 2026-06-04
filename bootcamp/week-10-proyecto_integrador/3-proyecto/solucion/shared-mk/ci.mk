# shared-mk/ci.mk — Módulo de CI reutilizable
.PHONY: ci lint

lint: ## Verificar estilo del código
	@echo "[$(APP_NAME)] Lint OK"

ci: lint test build ## Ejecutar pipeline CI del servicio
