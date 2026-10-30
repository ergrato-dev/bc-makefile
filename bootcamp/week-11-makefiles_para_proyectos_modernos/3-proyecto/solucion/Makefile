.PHONY: all install install-dev test lint run build docker-run up down info deploy-prod clean help
.DEFAULT_GOAL := help

# ── Configuración ──────────────────────────────────────────────────────────────
APP_NAME   := notificador
PYTHON     := python3
VENV       := .venv
PIP        := $(VENV)/bin/pip
PYTEST     := $(VENV)/bin/pytest
FLAKE8     := $(VENV)/bin/flake8
PY         := $(VENV)/bin/python

# ── Docker ─────────────────────────────────────────────────────────────────────
REGISTRY   := docker.io/miusuario
VERSION    := $(shell git describe --tags --always --dirty 2>/dev/null || echo 0.0.0)
BUILD_DATE := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
IMAGE      := $(APP_NAME):$(VERSION)
FULL_IMAGE := $(REGISTRY)/$(APP_NAME)

# ── Compose ────────────────────────────────────────────────────────────────────
COMPOSE    := $(shell docker compose version > /dev/null 2>&1 && echo "docker compose" || echo "docker-compose")

# ── Variables de entorno ────────────────────────────────────────────────────────
-include .env
export

# ── Instalación ────────────────────────────────────────────────────────────────
$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $@

$(VENV)/.installed-dev: requirements-dev.txt $(VENV)/.installed
	$(PIP) install -r requirements-dev.txt
	@touch $@
	@echo "Dependencias de desarrollo instaladas."

install: $(VENV)/.installed ## Instalar dependencias de runtime

install-dev: $(VENV)/.installed-dev ## Instalar dependencias de desarrollo

# ── Calidad ────────────────────────────────────────────────────────────────────
test: install-dev ## Ejecutar tests con pytest
	$(PYTEST) tests/ -v

lint: install-dev ## Verificar estilo con flake8
	$(FLAKE8) src/ --max-line-length=100

# ── Ejecución local ────────────────────────────────────────────────────────────
run: install ## Ejecutar servicio localmente con venv
	$(PY) src/main.py

# ── Docker ─────────────────────────────────────────────────────────────────────
build: ## Construir imagen Docker con metadata de versión
	docker build \
		--build-arg VERSION=$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(APP_NAME):$(VERSION) \
		-t $(APP_NAME):latest \
		.
	@echo "Imagen: $(IMAGE)"

docker-run: ## Ejecutar servicio en contenedor Docker
	docker run --rm --env-file .env $(APP_NAME):latest

# ── Compose ────────────────────────────────────────────────────────────────────
up: ## Levantar stack de desarrollo con docker-compose
	$(COMPOSE) up -d
	@echo "Stack arriba. Logs: make logs"

down: ## Detener stack
	$(COMPOSE) down
	@echo "Stack detenido."

# ── Información ────────────────────────────────────────────────────────────────
info: ## Mostrar información del proyecto
	@echo "=== $(APP_NAME) ==="
	@echo "Versión:    $(VERSION)"
	@echo "Imagen:     $(IMAGE)"
	@echo "Fecha:      $(BUILD_DATE)"
	@echo "Entorno:    $${ENV:-dev}"

# ── Despliegue ─────────────────────────────────────────────────────────────────
deploy-prod: build ## Desplegar en producción (pide confirmación)
	@read -p "¿Desplegar $(IMAGE) en PRODUCCIÓN? [y/N] " ans && [ "$$ans" = "y" ]
	@echo "Desplegando $(IMAGE) → producción..."
	$(COMPOSE) up -d

# ── Limpieza ───────────────────────────────────────────────────────────────────
clean: ## Eliminar venv y cachés de Python
	@rm -rf $(VENV) __pycache__ src/__pycache__ tests/__pycache__ .pytest_cache
	@find . -name "*.pyc" -delete
	@echo "Limpiado."

# ── Ayuda ──────────────────────────────────────────────────────────────────────
help: ## Mostrar ayuda
	@echo "$(APP_NAME) — Targets disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Versión: $(VERSION)"
	@echo "  Imagen:  $(FULL_IMAGE)"
