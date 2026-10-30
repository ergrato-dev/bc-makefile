.PHONY: help
.DEFAULT_GOAL := help

APP_NAME := infra
VERSION  := 1.0.0

# TODO: importar test.mk, deploy.mk y ci.mk (ruta: ../shared-mk/)
#       ci.mk depende de test: sin test.mk, `make ci` falla

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
