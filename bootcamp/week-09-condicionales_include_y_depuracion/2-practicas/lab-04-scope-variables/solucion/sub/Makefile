SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: report help
.DEFAULT_GOAL := help

VERSION := 0.0.0-hijo
ENV     ?= (no recibido)
CFLAGS  ?=

# override: el += se aplica aunque CFLAGS venga de la línea de comandos.
override CFLAGS += -fPIC

report: ## Reportar variables recibidas del padre
	@echo "=== Sub-make (MAKELEVEL=$(MAKELEVEL)) ==="
	@echo "ENV        = $(ENV)"
	@echo "VERSION    = $(VERSION)"
	@echo "SHARED_VAR = $(SHARED_VAR)"
	@echo "SECRET_VAR = $(SECRET_VAR)"
	@echo "CFLAGS     = $(CFLAGS)"
	@echo "MAKEFLAGS  = $(MAKEFLAGS)"

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
