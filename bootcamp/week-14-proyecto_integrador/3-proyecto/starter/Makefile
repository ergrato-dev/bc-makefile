.PHONY: all deps ci test deploy clean hooks-install hooks-uninstall check help
.DEFAULT_GOAL := help

SERVICES := backend frontend infra
GOALS    := build ci test deploy clean lint deps
ENV      ?= development
CONFIRM  ?=

# TODO: modo estricto (SHELL, .SHELLFLAGS con pipefail, .DELETE_ON_ERROR)

# TODO: define SERVICE_TARGETS (backend/build ... infra/lint) con $(foreach)
# y una regla única que ejecute:
#   $(MAKE) -C $(@D) $(@F) ENV=$(ENV) CONFIRM=$(CONFIRM)
# NO uses un bucle for: se traga los fallos de todos los servicios menos el último.

# TODO: all, deps, ci, test, deploy y clean solo con prerrequisitos
all: ## Construir todos los servicios

deps: ## Instalar dependencias (uv, pnpm) de todos los servicios

ci: ## Ejecutar pipeline CI en todos los servicios

test: ## Ejecutar tests en todos los servicios

deploy: ## Desplegar todos los servicios

clean: ## Limpiar artefactos de todos los servicios

# TODO: implementar hooks-install: chmod +x a los hooks y
#       `git config core.hooksPath '$(CURDIR)/hooks'`. Comenta que
#       `git commit --no-verify` los salta: el control real es make ci en CI.
# Imprimir: ✓ Hooks activos desde <ruta>/hooks
hooks-install: ## Instalar git hooks

# TODO: implementar hooks-uninstall con `git config --unset core.hooksPath`
hooks-uninstall: ## Desinstalar git hooks

# TODO: check depende de <servicio>/lint para cada servicio
check: ## Ejecutar checks rápidos (invocado por hooks)

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
