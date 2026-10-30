# shared-mk/docker.mk — Módulo Docker reutilizable
.PHONY: build-image push

IMAGE_NAME ?= $(APP_NAME)
VERSION    ?= 1.0.0
CI         ?= false

build-image: ## Construir imagen Docker
	@echo "[$(APP_NAME)] Construyendo imagen $(IMAGE_NAME):$(VERSION)"
	docker build --tag $(IMAGE_NAME):$(VERSION) .

# CI=true es una salvaguarda contra accidentes, no un control de acceso:
# `make push CI=true` la salta. El control real es que solo el runner de CI
# tenga credenciales del registry.
push: ## Publicar imagen (requiere CI=true)
ifneq ($(CI), true)
	$(error ERROR: push solo permitido cuando CI=true)
endif
	@echo "[$(APP_NAME)] Publicando $(IMAGE_NAME):$(VERSION)"
	docker push $(IMAGE_NAME):$(VERSION)
