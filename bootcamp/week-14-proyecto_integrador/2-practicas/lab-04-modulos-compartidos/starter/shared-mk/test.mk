# shared-mk/test.mk — Módulo de testing reutilizable
# Importar con: include ../shared-mk/test.mk
# Requiere: APP_NAME

.PHONY: test

# TODO: implementar target test
# Debe imprimir: [$(APP_NAME)] Ejecutando tests ...
# Luego imprimir: [$(APP_NAME)] ✓ Todos los tests pasaron
# Paso 8: con FAIL=<APP_NAME> la receta imprime "✗ Tests fallidos" y sale con 1.
# Pista: $(if $(filter $(APP_NAME),$(FAIL)),@echo "..."; exit 1)
FAIL ?=
test: ## Ejecutar tests del servicio
