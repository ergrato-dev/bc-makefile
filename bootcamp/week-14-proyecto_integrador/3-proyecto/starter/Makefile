.PHONY: all ci test deploy clean hooks-install hooks-uninstall check help
.DEFAULT_GOAL := help

SERVICES := backend frontend infra
ENV      ?= development

# TODO: implementar target all
# Debe ejecutar $(MAKE) -C $$svc build para cada servicio en SERVICES
all: ## Construir todos los servicios

# TODO: implementar target ci
# Debe ejecutar $(MAKE) -C $$svc ci para cada servicio en SERVICES
ci: ## Ejecutar pipeline CI en todos los servicios

# TODO: implementar target test
# Debe ejecutar $(MAKE) -C $$svc test para cada servicio en SERVICES
test: ## Ejecutar tests en todos los servicios

# TODO: implementar target deploy
# Debe pasar ENV y CONFIRM a cada submake: $(MAKE) -C $$svc deploy ENV=$(ENV) CONFIRM=$(CONFIRM)
deploy: ## Desplegar todos los servicios

# TODO: implementar target clean
# Debe ejecutar $(MAKE) -C $$svc clean para cada servicio en SERVICES
clean: ## Limpiar artefactos de todos los servicios

# TODO: implementar hooks-install
# Copiar hooks/* a .git/hooks/ con chmod +x
# Imprimir: ✓ Hooks instalados en .git/hooks/
hooks-install: ## Instalar git hooks

# TODO: implementar hooks-uninstall
hooks-uninstall: ## Desinstalar git hooks

# TODO: implementar check (invocado por los hooks)
# Ejecutar lint en todos los servicios
check: ## Ejecutar checks rápidos (invocado por hooks)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
