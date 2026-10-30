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

lint: ## Verificar estilo del código
	@echo "==> Lint"
	$(PYTHON) -m flake8 src/ --max-line-length=100

test: .stamps/deps ## Ejecutar suite de tests
	@echo "==> Tests"
	$(PYTHON) -m pytest tests/ -v

build-image: ## Construir imagen Docker
	@echo "==> Build Docker $(IMAGE_NAME):$(VERSION)"
	docker build --tag $(IMAGE_NAME):$(VERSION) .

push: ## Subir imagen al registry (requiere CI=true)
ifneq ($(CI), true)
	$(error ERROR: push solo permitido cuando CI=true)
endif
	@echo "==> Push $(IMAGE_NAME):$(VERSION)"
	docker push $(IMAGE_NAME):$(VERSION)

ci: lint test build-image ## Ejecutar pipeline completo: lint → test → build-image

clean: ## Eliminar artefactos
	rm -rf .stamps/ __pycache__ .pytest_cache

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
