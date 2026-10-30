SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all ci test deploy clean hooks-install hooks-uninstall check help
.DEFAULT_GOAL := help

SERVICES := backend frontend infra
GOALS    := build ci test deploy clean lint
ENV      ?= development
CONFIRM  ?=

# Un target phony por servicio y meta (backend/ci, infra/lint...): si un
# servicio falla, el build se detiene y CI queda en rojo.
SERVICE_TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(SERVICES)))
.PHONY: $(SERVICE_TARGETS)

$(SERVICE_TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F) ENV=$(ENV) CONFIRM=$(CONFIRM)

all: $(addsuffix /build,$(SERVICES)) ## Construir todos los servicios

ci: $(addsuffix /ci,$(SERVICES)) ## Ejecutar pipeline CI en todos los servicios

test: $(addsuffix /test,$(SERVICES)) ## Ejecutar tests en todos los servicios

deploy: $(addsuffix /deploy,$(SERVICES)) ## Desplegar todos los servicios

clean: $(addsuffix /clean,$(SERVICES)) ## Limpiar artefactos de todos los servicios

# core.hooksPath apunta a hooks/ versionado: no se copia nada a .git/hooks
# y funciona igual en worktrees. Recuerda que `git commit --no-verify` los
# salta: son una ayuda, no un control. El control real es `make ci` en CI.
hooks-install: ## Instalar git hooks del proyecto
	git config core.hooksPath '$(CURDIR)/hooks'
	@echo "✓ Hooks activos desde $(CURDIR)/hooks"

hooks-uninstall: ## Desinstalar git hooks
	-git config --unset core.hooksPath
	@echo "✓ Hooks desinstalados"

check: $(addsuffix /lint,$(SERVICES)) ## Ejecutar checks rápidos (invocado por hooks)
	@echo "✓ Checks OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
