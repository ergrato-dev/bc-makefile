# ============================================================
# Proyecto Semana 02 — Makefile parametrizable multi-entorno
# ============================================================
# Uso:
#   make config                    → muestra configuración dev (default)
#   make config ENV=staging        → muestra configuración staging
#   make deploy ENV=prod           → despliega en producción
#   make deploy ENV=prod VERSION=2.0.0
# ============================================================

.PHONY: config build test deploy clean help

.DEFAULT_GOAL := help

# ── Configuración del proyecto ────────────────────────────────
# TODO: define APP_NAME con ?= y valor "mywebservice"

# TODO: define ENV con ?= y valor "dev"

# TODO: define REGISTRY con ?= y valor "registry.local"

# TODO: define LOG_LEVEL con ?= y valor "info"

# ── Versión ───────────────────────────────────────────────────
# TODO: define GIT_VERSION con := capturando git describe --tags --always
#       Si no hay git, usar "0.1.0" como fallback
#       Pista: $(shell git describe --tags --always 2>/dev/null || echo "0.1.0")
#       Usa := y no ?=: ?= crea una variable recursiva y ejecutaría git en cada uso

# TODO: define VERSION con ?= y valor $(GIT_VERSION)

# TODO: define BUILD_DATE con := capturando la fecha actual (date +%F)

# ── Tags e imagen ─────────────────────────────────────────────
# TODO: define IMAGE_TAG con = (no :=) construyendo:
#       "$(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)"

# ── Base de datos ─────────────────────────────────────────────
# TODO: define DB_HOST con ?= y valor "localhost"

# TODO: define DB_NAME con = construyendo "$(APP_NAME)_$(ENV)"

# TODO: define DB_URL con = construyendo "postgres://$(DB_HOST):5432/$(DB_NAME)"

# ── Flags de build ────────────────────────────────────────────
# TODO: define BUILD_ARGS con ?= y valor vacío (configurable desde la CLI)
# TODO: añade --pull a BUILD_ARGS de forma que se conserve aunque el usuario
#       pase BUILD_ARGS por la línea de comandos. Pista: override + +=

config: ## muestra la configuración completa del entorno actual
	# TODO: imprime todas las variables relevantes con formato alineado
	# Ejemplo:
	#   @echo "Entorno:    $(ENV)"
	#   @echo "Versión:    $(VERSION)"
	#   ... (continúa con las demás)
	# Última línea: "Origen ENV: " seguido de lo que devuelve la función origin para ENV

build: ## construye la imagen de la aplicación
	# TODO: imprime líneas de build con el prefijo [build]
	# Incluye el IMAGE_TAG en el output
	# Incluye una línea "[build] Flags: " seguida de BUILD_ARGS

test: ## ejecuta la suite de pruebas
	# TODO: imprime líneas de test con el prefijo [test]
	# Incluye el entorno actual en el output

deploy: build test ## construye, prueba y despliega en el entorno configurado
	# TODO: imprime líneas de deploy con el prefijo [deploy]
	# Incluye IMAGE_TAG y DB_URL en el output

clean: ## elimina artefactos de build
	# TODO: borra el directorio dist/ si existe (sin error si no existe)
	# Usa: rm -rf dist/
	# Imprime "[clean] Limpiando artefactos..." y "[clean] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [ENV=dev|staging|prod] [VERSION=x.y.z]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
