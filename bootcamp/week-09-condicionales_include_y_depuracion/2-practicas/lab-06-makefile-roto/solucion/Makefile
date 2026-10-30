# Makefile corregido: 6 errores que Make reporta y 2 que no.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: ci build test lint deploy help
.DEFAULT_GOAL := help

APP_NAME := mi-app
ENV      ?= development

# FIX 1: -include. config.mk es opcional (overrides locales) y no está en git.
-include mk/config.mk

ifeq ($(ENV),production)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug
# FIX 2: faltaba endif; todo lo que seguía quedaba dentro de la rama else.
endif

# FIX 3: la receta empezaba con 8 espacios; Make exige un TAB.
# FIX 7: APP_NMAE no existe y Make la expandía a vacío sin avisar
#        (lo delata --warn-undefined-variables).
build: ## Compilar el proyecto
	@echo "Compilando $(APP_NAME) $(BUILD_FLAGS)"

# FIX 4: VERSION = v$(VERSION) se refería a sí misma al expandirse.
VERSION := 1.0.0

test: ## Ejecutar tests
	@echo "Tests OK"

# FIX 6: check-syntax no existía en ningún sitio. lint hace ahora el trabajo:
#        un dry-run con aviso de variables indefinidas para que 7 y 8 no vuelvan.
#        No incluye ci ni lint: $(MAKE) se ejecuta incluso con -n y recursaría.
lint: ## Detectar variables indefinidas en build y deploy
	@out=$$($(MAKE) --no-print-directory -n --warn-undefined-variables build deploy 2>&1); \
	if grep 'undefined variable' <<<"$$out"; then exit 1; fi
	@echo "Lint OK"

# FIX 5: ci dependía de deploy y deploy de ci. CI no despliega; deploy solo
#        necesita que los tests pasen.
ci: build test lint ## Ejecutar pipeline completo
	@echo "CI completo"

# FIX 8: el ifeq se evaluaba al leer el archivo, con ENV=development, antes de
#        que existiera la variable de target. DEPLOY_FLAGS también es de target.
deploy: ENV := production
deploy: DEPLOY_FLAGS := --confirm

deploy: test ## Desplegar en production
	@echo "Desplegando $(APP_NAME) $(VERSION) en $(ENV) $(DEPLOY_FLAGS)"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
