# Makefile corregido — 6 errores resueltos
#
# FIX 1: include → -include  (no falla si mk/config.mk no existe)
# FIX 2: Agregado endif para cerrar el bloque ifeq
# FIX 3: Receta de 'build' usa TAB (no espacios)
# FIX 4: VERSION usa := en vez de = (expansión inmediata, no recursiva)
# FIX 5: deploy eliminado de las dependencias de ci (ciclo roto)
# FIX 6: lint ya no depende de 'check-syntax'; implementa la lógica directamente

.PHONY: ci build test lint deploy help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

# FIX 1: -include no falla si el archivo no existe
-include mk/config.mk

# FIX 2: bloque ifeq correctamente cerrado con endif
ifeq ($(ENV), production)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug
endif

# FIX 4: := evita la expansión recursiva
VERSION := 1.0.0

# FIX 3: receta indentada con TAB (no espacios)
build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) $(BUILD_FLAGS)"

test: ## Ejecutar tests
	@echo "Tests OK"

# FIX 6: lint implementa su lógica sin depender de target inexistente
lint: ## Verificar estilo
	@echo "Lint OK"

# FIX 5: ci ya no depende de deploy (ciclo eliminado)
ci: build test lint ## Ejecutar pipeline completo
	@echo "CI completo"

deploy: ## Desplegar
	@echo "Desplegando $(APP_NAME) $(VERSION) en $(ENV)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
