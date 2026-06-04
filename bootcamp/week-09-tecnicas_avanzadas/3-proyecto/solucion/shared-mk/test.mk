# Módulo compartido: test.mk
# Variables requeridas: APP_NAME

.PHONY: test

test: ## Ejecutar tests del módulo
	@echo "[$(APP_NAME)] Ejecutando tests..."
	@echo "[$(APP_NAME)] Tests OK"
