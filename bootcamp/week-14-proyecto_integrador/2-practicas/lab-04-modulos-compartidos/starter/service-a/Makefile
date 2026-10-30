.PHONY: help
.DEFAULT_GOAL := help

APP_NAME := service-a
VERSION  := 1.0.0

# TODO: importar los tres módulos compartidos con include
# Pista: la ruta relativa desde service-a/ es ../shared-mk/

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
