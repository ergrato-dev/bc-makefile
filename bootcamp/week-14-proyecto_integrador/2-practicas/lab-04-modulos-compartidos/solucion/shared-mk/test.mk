# shared-mk/test.mk — Módulo de testing reutilizable
.PHONY: test

# FAIL=<servicio> simula un test roto en ese servicio, para comprobar que el
# fallo se propaga hasta el Makefile raíz.
FAIL ?=

test: ## Ejecutar tests del servicio
	@echo "[$(APP_NAME)] Ejecutando tests ..."
	$(if $(filter $(APP_NAME),$(FAIL)),@echo "[$(APP_NAME)] ✗ Tests fallidos"; exit 1)
	@echo "[$(APP_NAME)] ✓ Todos los tests pasaron"
