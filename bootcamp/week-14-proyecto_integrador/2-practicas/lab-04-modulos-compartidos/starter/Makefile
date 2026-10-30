# Orquestador de los dos servicios (pasos 7 a 9 del README)
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all test clean help
.DEFAULT_GOAL := help

SERVICES := service-a service-b
GOALS    := build test clean

# TODO 1: SERVICE_TARGETS con $(foreach) y $(addsuffix): service-a/build,
#         service-b/build, service-a/test... y decláralos .PHONY.
# TODO 2: una sola regla para todos ellos cuya receta sea
#           @$(MAKE) --no-print-directory -C $(@D) $(@F)
#         Nunca `for s in $(SERVICES); do $(MAKE) -C $$s; done`: el bucle se
#         traga los fallos de todos los servicios menos el último y anula -j.

# TODO 3: all, test y clean solo con prerrequisitos ($(addsuffix /build,...))
all: ## Construir todos los servicios

test: ## Ejecutar los tests de todos los servicios

clean: ## Limpiar todos los servicios

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
