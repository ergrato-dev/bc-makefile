.PHONY: all ci test deploy clean hooks-install hooks-uninstall check help
.DEFAULT_GOAL := help

SERVICES := backend frontend infra
ENV      ?= development
CONFIRM  ?=

all: ## Construir todos los servicios
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc build; \
	done

ci: ## Ejecutar pipeline CI en todos los servicios
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc ci; \
	done

test: ## Ejecutar tests en todos los servicios
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc test; \
	done

deploy: ## Desplegar todos los servicios
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc deploy ENV=$(ENV) CONFIRM=$(CONFIRM); \
	done

clean: ## Limpiar artefactos de todos los servicios
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc clean; \
	done

hooks-install: ## Instalar git hooks del proyecto
	@for hook in pre-commit pre-push; do \
		cp hooks/$$hook .git/hooks/$$hook; \
		chmod +x .git/hooks/$$hook; \
	done
	@echo "✓ Hooks instalados en .git/hooks/"

hooks-uninstall: ## Desinstalar git hooks
	@rm -f .git/hooks/pre-commit .git/hooks/pre-push
	@echo "✓ Hooks desinstalados"

check: ## Ejecutar checks rápidos (invocado por hooks)
	@for svc in $(SERVICES); do \
		$(MAKE) -C $$svc lint; \
	done
	@echo "✓ Checks OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
