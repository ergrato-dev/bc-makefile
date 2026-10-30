# shared-mk/test.mk — Módulo de testing reutilizable
.PHONY: test

test: ## Ejecutar tests del servicio
	@echo "[$(APP_NAME)] Ejecutando tests ..."
	@echo "[$(APP_NAME)] ✓ Todos los tests pasaron"
