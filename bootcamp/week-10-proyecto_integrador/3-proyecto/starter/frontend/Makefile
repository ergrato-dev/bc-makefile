.PHONY: help
.DEFAULT_GOAL := help

APP_NAME   := frontend
IMAGE_NAME := mi-plataforma-frontend
VERSION    := 1.0.0

# TODO: importar los 5 módulos compartidos (ruta: ../shared-mk/)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
