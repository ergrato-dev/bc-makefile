.PHONY: show-scope override-demo help
.DEFAULT_GOAL := help

ENV        ?= development
VERSION    := 1.0.0
SHARED_VAR := valor-compartido
SECRET_VAR ?= no-secret

# --------------------------------------------------------------------------
# TODO 1: Exporta SHARED_VAR para que llegue al submake automáticamente.
#         NO exportes SECRET_VAR (usa unexport si ya está en el entorno).
# --------------------------------------------------------------------------
# TODO: export SHARED_VAR
# TODO: unexport SECRET_VAR

# --------------------------------------------------------------------------
# TODO 2: Implementa 'show-scope' que invoca $(MAKE) -C sub report
#         pasando ENV explícitamente en la línea de comando.
#         El submake imprimirá qué variables recibió.
# --------------------------------------------------------------------------
show-scope: ## Mostrar qué variables llegan al submake
	@echo "=== Padre invocando submake ==="
	# TODO: @$(MAKE) -C sub report ENV=$(ENV)

# --------------------------------------------------------------------------
# TODO 3: Implementa 'override-demo' que invoca el submake pasando VERSION
#         con override para que el hijo use el valor del padre.
# --------------------------------------------------------------------------
override-demo: ## Demostrar paso de VERSION con override
	@echo "=== override-demo: VERSION=$(VERSION) ==="
	# TODO: @$(MAKE) -C sub report VERSION=$(VERSION)

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
