# Orquestador de los dos servicios (SOLUCIÓN)
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all test clean help
.DEFAULT_GOAL := help

SERVICES := service-a service-b
GOALS    := build test clean

# Un target phony por servicio y meta: service-a/build, service-b/test...
# Make ve cada sub-make como un target: un fallo detiene el build, -j los
# reparte y $(MAKE) les pasa el jobserver. Nunca un bucle for.
SERVICE_TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(SERVICES)))
.PHONY: $(SERVICE_TARGETS)

$(SERVICE_TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F)

all: $(addsuffix /build,$(SERVICES)) ## Construir todos los servicios

test: $(addsuffix /test,$(SERVICES)) ## Ejecutar los tests de todos los servicios

clean: $(addsuffix /clean,$(SERVICES)) ## Limpiar todos los servicios

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
