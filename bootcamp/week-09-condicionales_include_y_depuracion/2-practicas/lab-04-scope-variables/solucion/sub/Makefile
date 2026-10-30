SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: report help
.DEFAULT_GOAL := help

VERSION    := 0.0.0-hijo
ENV        ?= (no recibido)

report: ## Reportar variables recibidas del padre
	@echo "=== Variables en el submake ==="
	@echo "ENV        = $(ENV)"
	@echo "VERSION    = $(VERSION)"
	@echo "SHARED_VAR = $(SHARED_VAR)"
	@echo "SECRET_VAR = $(SECRET_VAR)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
