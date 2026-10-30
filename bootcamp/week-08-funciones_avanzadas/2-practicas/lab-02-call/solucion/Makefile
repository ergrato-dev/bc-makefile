SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all demo check-services clean help
.DEFAULT_GOAL := help

SERVICES := api worker monitor
BUILD    := build

define service_info
	@echo "[$1] URL: http://localhost:$2"
endef

build_path = $(BUILD)/$1/$1

PORT_api     := 8080
PORT_worker  := 8081
PORT_monitor := 9090

demo: ## Mostrar información de servicios
	@echo "=== Servicios del sistema ==="
	$(call service_info,api,$(PORT_api))
	$(call service_info,worker,$(PORT_worker))
	$(call service_info,monitor,$(PORT_monitor))
	@echo ""
	@echo "Rutas de build:"
	@$(foreach svc,$(SERVICES),echo "  $(svc): $(call build_path,$(svc))";)

check-services: ## Verificar todos los servicios
	@$(foreach svc,$(SERVICES),mkdir -p $(BUILD)/$(svc) && echo "$(svc) OK";)

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
