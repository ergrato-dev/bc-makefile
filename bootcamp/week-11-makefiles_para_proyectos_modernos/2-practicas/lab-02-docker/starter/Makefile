# TODO 0: Preámbulo estricto (Semana 03), antes de cualquier otra línea:
#         SHELL := bash
#         .SHELLFLAGS := -eu -o pipefail -c
#         .DELETE_ON_ERROR:

.PHONY: all build run push info clean-image help
.DEFAULT_GOAL := help

IMAGE_NAME  := mi-app
REGISTRY    := docker.io/miusuario
VERSION     := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
BUILD_DATE  := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
FULL_IMAGE  := $(REGISTRY)/$(IMAGE_NAME)
PORT_HOST   := 8080
PORT_CONT   := 8080

# TODO 1: Define el target 'build'
#   Construye la imagen Docker etiquetándola como $(IMAGE_NAME):$(VERSION)
#   Inyecta --build-arg VERSION=$(VERSION) y --build-arg BUILD_DATE=$(BUILD_DATE)
#   Imprime "Imagen: $(IMAGE_NAME):$(VERSION)" al terminar


# TODO 2: Define el target 'run'
#   Ejecuta el contenedor con docker run --rm
#   Expone el puerto: -p $(PORT_HOST):$(PORT_CONT)
#   Usa la imagen $(IMAGE_NAME):$(VERSION) y publica el puerto solo en 127.0.0.1


# TODO 3: Define el target 'push'
#   Etiqueta la imagen local como $(FULL_IMAGE):$(VERSION) y publícala.
#   No publiques `latest`: es mutable y no dice qué código corre.
#   Pista: docker tag ... && docker push ...


# TODO 4: Define el target 'info'
#   Usa docker image inspect para mostrar nombre, tamaño y fecha de creación
#   Pista: docker image inspect $(IMAGE_NAME):$(VERSION) --format '{{.Size}} bytes'
#   Imprime al menos: nombre, versión, tamaño


# TODO 5: Define el target 'clean-image'
#   Elimina la imagen local $(IMAGE_NAME):$(VERSION)
#   Pista: docker rmi $(IMAGE_NAME):$(VERSION) 2>/dev/null || true
#   Imprime "Imagen $(IMAGE_NAME):$(VERSION) eliminada."


# TODO 6: Build incremental. Una imagen no es un archivo y Make no ve su fecha,
#   así que 'build' reconstruye siempre. Arréglalo:
#   - Variables: IID_DIR := .build   y   IID_FILE := $(IID_DIR)/$(IMAGE_NAME)-$(VERSION).iid
#   - Target de archivo $(IID_FILE) con prerrequisitos Dockerfile y app.py:
#       mkdir -p $(@D) y el docker build del TODO 1 con '--iidfile $@' añadido
#   - 'build' pasa a depender de $(IID_FILE) y solo imprime el mensaje
#   - 'clean-image' borra también $(IID_DIR), con su guarda de variable vacía


help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
