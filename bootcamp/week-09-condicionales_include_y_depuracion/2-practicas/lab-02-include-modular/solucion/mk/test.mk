# Módulo: test.mk — targets de testing
# Requiere: APP_NAME

.PHONY: test

test: ## Ejecutar tests
	@echo "[test] Ejecutando tests de $(APP_NAME)"
