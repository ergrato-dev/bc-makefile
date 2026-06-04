# Makefile con 6 errores intencionales
# Objetivo: diagnosticar y corregir cada uno con las herramientas de la semana
# Ejecuta: make ci 2>&1 | head -20   para ver el primer error

.PHONY: ci build test help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

# ERROR 1: Este include falla si el archivo no existe.
# Pista: ¿cómo se hace opcional un include en Make?
include mk/config.mk

# ERROR 2: Este bloque condicional nunca se cierra.
# Pista: ¿qué directiva cierra un ifeq?
ifeq ($(ENV), production)
  BUILD_FLAGS := --release

# ERROR 3: La siguiente receta usa espacios en lugar de TAB.
# Pista: Make exige TAB al inicio de cada línea de receta.
# (La siguiente línea tiene 8 espacios, no un TAB)
build: ## Compilar el proyecto
        @echo "Compilando $(APP_NAME)"

# ERROR 4: Esta variable se referencia a sí misma con '=' (recursiva infinita).
# Pista: ¿qué operador de asignación evita la expansión recursiva?
VERSION = v$(VERSION)

test: ## Ejecutar tests
	@echo "Tests OK"

# ERROR 5: Dependencia circular.
# ci depende de deploy, y deploy depende de ci.
# Pista: Make lo detecta con un warning y descarta la dependencia.
ci: build test deploy ## Ejecutar pipeline completo
	@echo "CI completo"

deploy: ci ## Desplegar
	@echo "Desplegando $(APP_NAME) $(VERSION)"

# ERROR 6: El target 'lint' depende de 'check-syntax' que no existe en ningún lado.
# Pista: Make reporta "No rule to make target 'check-syntax'".
lint: check-syntax ## Verificar estilo
	@echo "Lint OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
