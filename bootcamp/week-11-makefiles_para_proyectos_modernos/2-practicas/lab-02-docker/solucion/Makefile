SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build run push info clean-image help
.DEFAULT_GOAL := help

IMAGE_NAME  := mi-app
REGISTRY    := docker.io/miusuario
VERSION     := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
BUILD_DATE  := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
FULL_IMAGE  := $(REGISTRY)/$(IMAGE_NAME)
PORT_HOST   := 8080
PORT_CONT   := 8080
# La imagen no es un archivo: Make no puede ver su fecha. --iidfile escribe
# el ID de la imagen en un archivo que sí puede comparar con sus fuentes.
IID_DIR     := .build
IID_FILE    := $(IID_DIR)/$(IMAGE_NAME)-$(VERSION).iid

$(IID_FILE): Dockerfile app.py
	@mkdir -p $(@D)
	docker build \
		--iidfile $@ \
		--build-arg VERSION=$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(IMAGE_NAME):$(VERSION) \
		.

build: $(IID_FILE) ## Construir imagen Docker (solo si cambian Dockerfile o app.py)
	@echo "Imagen: $(IMAGE_NAME):$(VERSION) ($$(cut -c1-19 $<))"

# 127.0.0.1: el puerto solo es accesible desde tu máquina, no desde la red.
run: ## Ejecutar contenedor localmente
	docker run --rm -p 127.0.0.1:$(PORT_HOST):$(PORT_CONT) $(IMAGE_NAME):$(VERSION)

# Solo se publica el tag de versión: `latest` cambia en cada push y no
# permite saber qué código corre en producción ni volver atrás.
push: build ## Etiquetar y publicar imagen en registry
	docker tag $(IMAGE_NAME):$(VERSION) $(FULL_IMAGE):$(VERSION)
	docker push $(FULL_IMAGE):$(VERSION)
	@echo "Publicado: $(FULL_IMAGE):$(VERSION)"

info: ## Mostrar metadata de la imagen local
	@echo "Nombre:   $(IMAGE_NAME):$(VERSION)"
	@docker image inspect $(IMAGE_NAME):$(VERSION) \
		--format 'Tamaño:   {{.Size}} bytes{{"\n"}}Creada:   {{.Created}}' 2>/dev/null \
		|| echo "(imagen no construida — ejecuta make build primero)"

clean-image: ## Eliminar imagen local y su archivo de ID
	$(if $(IID_DIR),,$(error IID_DIR vacía: rm -rf no se ejecuta))
	@docker rmi $(IMAGE_NAME):$(VERSION) 2>/dev/null || true
	@rm -rf -- '$(IID_DIR)'
	@echo "Imagen $(IMAGE_NAME):$(VERSION) eliminada."

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
