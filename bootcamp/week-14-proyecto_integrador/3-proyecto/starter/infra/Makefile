.PHONY: help
.DEFAULT_GOAL := help

APP_NAME := infra
VERSION  := 1.0.0

# TODO: importar build.mk, c.mk, test.mk, deploy.mk y ci.mk (ruta: ../shared-mk/)
#       infra compila un healthcheck en C (src/, include/): c.mk le añade
#       el binario a build y define cómo se prueba.

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
