# shared-mk/test.mk
.PHONY: test

# FAIL=<servicio> simula un test roto en ese servicio. Sirve para comprobar
# que el fallo de un servicio se propaga hasta `make ci` en la raíz.
FAIL     ?=
# Cada módulo de lenguaje (python.mk, node.mk, c.mk) define su TEST_CMD.
TEST_CMD ?=

# TODO: implementar test (prerrequisito: deps)
# Imprime [$(APP_NAME)] Ejecutando tests ...
# Si APP_NAME está en FAIL ($(filter $(APP_NAME),$(FAIL)) no vacío):
#   imprime [$(APP_NAME)] ✗ Tests fallidos (FAIL=$(FAIL)) y sale con exit 1
# Después ejecuta $(TEST_CMD) e imprime [$(APP_NAME)] ✓ Todos los tests pasaron
test: ## Ejecutar tests del servicio
