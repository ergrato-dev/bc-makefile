.PHONY: ci lint test build-image check-nonroot push deps clean help
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

# TODO: implementar target lint
# Debe ejecutar: flake8 src/ --max-line-length=100
lint: ## Verificar estilo del código

# TODO: implementar target test con dependencia en .stamps/deps
# Debe ejecutar: pytest tests/ -v
test: ## Ejecutar suite de tests

# TODO: implementar target build-image
# Debe ejecutar: docker build --tag $(IMAGE_NAME):$(VERSION) .
build-image: ## Construir imagen Docker

# TODO: implementar check-nonroot (depende de build-image). Lee el usuario de
# la imagen con docker image inspect --format '{{.Config.User}}' y falla si
# está vacío, es root o es 0. Imprime: ✓ <imagen> corre como <usuario>
check-nonroot: ## Verificar que la imagen no corre como root

# TODO: implementar target push con guardia CI=true
# Si CI != "true": $(error ERROR: push solo permitido cuando CI=true)
# Si CI == "true": docker push $(IMAGE_NAME):$(VERSION)
# CI=true es una salvaguarda contra accidentes, no un control de acceso:
# `make push CI=true` la salta. El control real es que solo el runner de CI
# tenga credenciales del registry.
push: ## Subir imagen al registry (requiere CI=true)

# TODO: encadenar lint → test → check-nonroot (que ya construye la imagen)
ci: ## Ejecutar pipeline completo: lint → test → build-image → check-nonroot

clean: ## Eliminar artefactos
	rm -rf .stamps/ __pycache__ .pytest_cache

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
