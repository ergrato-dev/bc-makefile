# shared-mk/docker.mk
.PHONY: build-image push

IMAGE_NAME ?= $(APP_NAME)
VERSION    ?= 1.0.0
CI         ?= false

# TODO: implementar build-image
# Ejecuta: docker build --tag $(IMAGE_NAME):$(VERSION) .
build-image: ## Construir imagen Docker

# TODO: implementar push con guardia CI=true
# Si CI != "true": $(error ERROR: push solo permitido cuando CI=true)
# CI=true es una salvaguarda contra accidentes, no un control de acceso:
# `make push CI=true` la salta. El control real es que solo el runner de CI
# tenga credenciales del registry.
push: ## Publicar imagen (requiere CI=true)
