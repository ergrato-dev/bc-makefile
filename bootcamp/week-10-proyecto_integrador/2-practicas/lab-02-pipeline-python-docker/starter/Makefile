.PHONY: ci lint test build-image push deps clean help
.DEFAULT_GOAL := help

IMAGE_NAME := mi-servicio
VERSION    := $(shell git describe --tags --always 2>/dev/null || echo dev)
PYTHON     := python3
CI         ?= false

.stamps/:
	mkdir -p $@

.stamps/deps: requirements.txt | .stamps/
	$(PYTHON) -m pip install -r $< -q
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

# TODO: implementar target push con guardia CI=true
# Si CI != "true": $(error ERROR: push solo permitido cuando CI=true)
# Si CI == "true": docker push $(IMAGE_NAME):$(VERSION)
push: ## Subir imagen al registry (requiere CI=true)

# TODO: encadenar lint → test → build-image como dependencias de ci
ci: ## Ejecutar pipeline completo: lint → test → build-image

clean: ## Eliminar artefactos
	rm -rf .stamps/ __pycache__ .pytest_cache

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
