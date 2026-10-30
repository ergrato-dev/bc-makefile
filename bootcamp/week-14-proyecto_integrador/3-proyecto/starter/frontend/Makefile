.PHONY: help
.DEFAULT_GOAL := help

APP_NAME   := frontend
IMAGE_NAME := mi-plataforma-frontend
VERSION    := 1.0.0

# TODO: importar build.mk, node.mk, test.mk, docker.mk, deploy.mk y ci.mk
#       (ruta: ../shared-mk/), con build.mk el primero: define BUILD_DIR

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
