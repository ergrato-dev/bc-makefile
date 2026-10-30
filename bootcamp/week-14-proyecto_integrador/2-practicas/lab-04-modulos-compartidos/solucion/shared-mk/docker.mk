# shared-mk/docker.mk — Módulo Docker reutilizable
.PHONY: build-image push

IMAGE_NAME ?= $(APP_NAME)

build-image: ## Construir imagen Docker
	@echo "[$(APP_NAME)] Construyendo imagen $(IMAGE_NAME):$(VERSION)"
	docker build --tag $(IMAGE_NAME):$(VERSION) .

push: ## Publicar imagen Docker
	@echo "[$(APP_NAME)] Publicando $(IMAGE_NAME):$(VERSION)"
	docker push $(IMAGE_NAME):$(VERSION)
