# shared-mk/test.mk — Módulo de testing reutilizable
.PHONY: test

# FAIL=<servicio> simula un test roto en ese servicio. Sirve para comprobar
# que el fallo de un servicio se propaga hasta `make ci` en la raíz.
FAIL     ?=
# Cada módulo de lenguaje (python.mk, node.mk, c.mk) define su TEST_CMD.
TEST_CMD ?=

test: deps ## Ejecutar tests del servicio
	@echo "[$(APP_NAME)] Ejecutando tests ..."
	$(if $(filter $(APP_NAME),$(FAIL)),@echo "[$(APP_NAME)] ✗ Tests fallidos (FAIL=$(FAIL))"; exit 1)
	$(TEST_CMD)
	@echo "[$(APP_NAME)] ✓ Todos los tests pasaron"
