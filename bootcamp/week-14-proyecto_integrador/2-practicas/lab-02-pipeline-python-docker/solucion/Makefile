SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: ci lint test build-image push deps clean help
.DEFAULT_GOAL := help

IMAGE_NAME := mi-servicio
VERSION    := $(shell git describe --tags --always 2>/dev/null || echo dev)
UV         := uv
VENV       := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN        := $(UV) run --no-sync
CI         ?= false

.stamps/:
	mkdir -p $@

.stamps/deps: pyproject.toml uv.lock | .stamps/
	$(UV) sync --locked --quiet
	touch $@

deps: .stamps/deps ## Instalar dependencias de desarrollo

lint: .stamps/deps ## Verificar estilo del código
	@echo "==> Lint"
	$(RUN) flake8 src/ --max-line-length=100

test: .stamps/deps ## Ejecutar suite de tests
	@echo "==> Tests"
	$(RUN) pytest tests/ -v

build-image: ## Construir imagen Docker
	@echo "==> Build Docker $(IMAGE_NAME):$(VERSION)"
	docker build --tag $(IMAGE_NAME):$(VERSION) .

# CI=true es una salvaguarda contra accidentes, no un control de acceso:
# `make push CI=true` la salta. El control real es que solo el runner de CI
# tenga credenciales del registry.
push: ## Subir imagen al registry (requiere CI=true)
ifneq ($(CI), true)
	$(error ERROR: push solo permitido cuando CI=true)
endif
	@echo "==> Push $(IMAGE_NAME):$(VERSION)"
	docker push $(IMAGE_NAME):$(VERSION)

ci: lint test build-image ## Ejecutar pipeline completo: lint → test → build-image

clean: ## Eliminar artefactos
	rm -rf .stamps/ '$(VENV)' __pycache__ .pytest_cache

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
