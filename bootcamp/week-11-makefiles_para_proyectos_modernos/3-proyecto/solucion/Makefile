SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install install-dev test lint format format-check check run build docker-run up down info deploy-prod clean help
.DEFAULT_GOAL := help

# ── Configuración ──────────────────────────────────────────────────────────────
APP_NAME   := notificador
UV         := uv
VENV       := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN        := $(UV) run --no-sync
PYTEST     := $(RUN) pytest
RUFF       := $(RUN) ruff

# ── Docker ─────────────────────────────────────────────────────────────────────
REGISTRY   := docker.io/miusuario
VERSION    := $(shell git describe --tags --always --dirty 2>/dev/null || echo 0.0.0)
BUILD_DATE := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
IMAGE      := $(APP_NAME):$(VERSION)
FULL_IMAGE := $(REGISTRY)/$(APP_NAME)

# ── Compose ────────────────────────────────────────────────────────────────────
# Compose v2, integrado en Docker. docker-compose (v1) está en EOL desde 2023.
COMPOSE    := docker compose

# ── Variables de entorno ────────────────────────────────────────────────────────
# .env se parsea como Makefile: valores sin `$`, sin comillas y sin `#`.
-include .env
# Sin .env, `export` mandaría ENV vacía y la app no aplicaría su valor por defecto.
ENV       ?= dev
LOG_LEVEL ?= INFO
# Solo lo que lee la app; nunca `export` a secas.
export ENV LOG_LEVEL SMTP_HOST SMTP_PORT

# ── Instalación ────────────────────────────────────────────────────────────────
# Runtime: sin el grupo dev. --inexact no desinstala lo que ya hubiera
# (si no, `make run` borraría pytest y el sentinel de dev quedaría mintiendo).
$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked --no-dev --inexact
	@touch $@

# Desarrollo: runtime + grupo dev de pyproject.toml
$(VENV)/.installed-dev: $(VENV)/.installed
	$(UV) sync --locked
	@touch $@
	@echo "Dependencias de desarrollo instaladas."

install: $(VENV)/.installed ## Instalar dependencias de runtime

install-dev: $(VENV)/.installed-dev ## Instalar dependencias de desarrollo

# ── Calidad ────────────────────────────────────────────────────────────────────
test: install-dev ## Ejecutar tests con pytest
	$(PYTEST) tests/ -v

lint: install-dev ## Analizar el código con ruff check
	$(RUFF) check src/

format: install-dev ## Reformatear src/ y tests/ con ruff format
	$(RUFF) format src/ tests/

# --check no escribe: sale con error si ruff format cambiaría algo. Es lo que corre CI.
format-check: install-dev ## Comprobar el formato sin modificar archivos
	$(RUFF) format --check src/ tests/

# Sin receta: solo agrupa. Falla en cuanto falla cualquiera de los tres.
check: format-check lint test ## Puerta de CI: formato, lint y tests

# ── Ejecución local ────────────────────────────────────────────────────────────
run: install ## Ejecutar servicio localmente con uv
	$(RUN) python src/main.py

# ── Docker ─────────────────────────────────────────────────────────────────────
build: ## Construir imagen Docker con metadata de versión
	docker build \
		--build-arg VERSION=$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(APP_NAME):$(VERSION) \
		.
	@echo "Imagen: $(IMAGE)"

docker-run: ## Ejecutar servicio en contenedor Docker
	docker run --rm --env-file .env $(IMAGE)

# ── Compose ────────────────────────────────────────────────────────────────────
up: ## Levantar stack de desarrollo con docker compose
	$(COMPOSE) up -d
	@echo "Stack arriba."

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
	@printf '¿Desplegar $(IMAGE) en PRODUCCIÓN? [y/N] '; read -r ans; [ "$$ans" = "y" ]
	@echo "Desplegando $(IMAGE) → producción..."
	$(COMPOSE) up -d

# ── Limpieza ───────────────────────────────────────────────────────────────────
clean: ## Eliminar venv y cachés de Python
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' __pycache__ src/__pycache__ tests/__pycache__ .pytest_cache .ruff_cache
	@find . -name "*.pyc" -delete
	@echo "Limpiado."

# ── Ayuda ──────────────────────────────────────────────────────────────────────
help: ## Mostrar ayuda
	@echo "$(APP_NAME) — Targets disponibles:"
	@echo ""
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Versión: $(VERSION)"
	@echo "  Imagen:  $(FULL_IMAGE)"
