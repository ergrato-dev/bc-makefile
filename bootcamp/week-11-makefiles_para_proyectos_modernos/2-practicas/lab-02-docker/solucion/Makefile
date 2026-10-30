.PHONY: all build run push info clean-image help
.DEFAULT_GOAL := help

IMAGE_NAME  := mi-app
REGISTRY    := docker.io/miusuario
VERSION     := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
BUILD_DATE  := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
FULL_IMAGE  := $(REGISTRY)/$(IMAGE_NAME)
PORT_HOST   := 8080
PORT_CONT   := 8080

build: ## Construir imagen Docker con metadata de versión
	docker build \
		--build-arg VERSION=$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		.
	@echo "Imagen: $(IMAGE_NAME):$(VERSION)"

run: ## Ejecutar contenedor localmente
	docker run --rm -p $(PORT_HOST):$(PORT_CONT) $(IMAGE_NAME):latest

push: build ## Etiquetar y publicar imagen en registry
	docker tag $(IMAGE_NAME):$(VERSION) $(FULL_IMAGE):$(VERSION)
	docker tag $(IMAGE_NAME):latest $(FULL_IMAGE):latest
	docker push $(FULL_IMAGE):$(VERSION)
	docker push $(FULL_IMAGE):latest
	@echo "Publicado: $(FULL_IMAGE):$(VERSION)"

info: ## Mostrar metadata de la imagen local
	@echo "Nombre:   $(IMAGE_NAME):$(VERSION)"
	@docker image inspect $(IMAGE_NAME):$(VERSION) \
		--format 'Tamaño:   {{.Size}} bytes\nCreada:   {{.Created}}' 2>/dev/null \
		|| echo "(imagen no construida — ejecuta make build primero)"

clean-image: ## Eliminar imagen local
	@docker rmi $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest 2>/dev/null || true
	@echo "Imagen $(IMAGE_NAME):$(VERSION) eliminada."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
