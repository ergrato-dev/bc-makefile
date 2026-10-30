# shared-mk/docker.mk — Módulo Docker reutilizable
# Importar con: include ../shared-mk/docker.mk
# Requiere: APP_NAME, VERSION
# Opcional: IMAGE_NAME (default: APP_NAME)

.PHONY: build-image push

IMAGE_NAME ?= $(APP_NAME)

# TODO: implementar target build-image
# Debe ejecutar: docker build --tag $(IMAGE_NAME):$(VERSION) .
# Imprimir: [$(APP_NAME)] Construyendo imagen $(IMAGE_NAME):$(VERSION)
build-image: ## Construir imagen Docker

# TODO: implementar target push
# Debe ejecutar: docker push $(IMAGE_NAME):$(VERSION)
# Imprimir: [$(APP_NAME)] Publicando $(IMAGE_NAME):$(VERSION)
push: ## Publicar imagen Docker
