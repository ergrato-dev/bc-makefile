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
# TODO A: Agrega '-include .env' y 'export' aquí para propagar variables al shell


# ── Instalación ────────────────────────────────────────────────────────────────
# TODO 1: Target '$(VENV)/.installed' con dependencia requirements.txt
#   - crea el venv, actualiza pip, instala requirements.txt
#   - termina con @touch $@


# TODO 2: Target '$(VENV)/.installed-dev' con dependencia requirements-dev.txt y $(VENV)/.installed
#   - instala requirements-dev.txt sobre el venv existente
#   - termina con @touch $@


# TODO 3: Target 'install' como alias de '$(VENV)/.installed' con comentario ##


# TODO 4: Target 'install-dev' como alias de '$(VENV)/.installed-dev' con comentario ##


# ── Calidad ────────────────────────────────────────────────────────────────────
# TODO 5: Target 'test' que dependa de 'install-dev' y ejecute $(PYTEST) tests/ -v


# TODO 6: Target 'lint' que dependa de 'install-dev' y ejecute $(FLAKE8) src/ --max-line-length=100


# ── Ejecución ──────────────────────────────────────────────────────────────────
# TODO 7: Target 'run' que dependa de 'install' y ejecute $(PY) src/main.py


# ── Docker ─────────────────────────────────────────────────────────────────────
# TODO 8: Target 'build' que:
#   - ejecute docker build con --build-arg VERSION=$(VERSION) y --build-arg BUILD_DATE=$(BUILD_DATE)
#   - etiquete como $(APP_NAME):$(VERSION) y $(APP_NAME):latest
#   - imprima "Imagen: $(IMAGE)" al terminar


# TODO 9: Target 'docker-run' que ejecute el contenedor con --rm y --env-file .env


# ── Compose ────────────────────────────────────────────────────────────────────
# TODO 10: Target 'up' — $(COMPOSE) up -d con mensaje de confirmación


# TODO 11: Target 'down' — $(COMPOSE) down con mensaje de confirmación


# ── Información ────────────────────────────────────────────────────────────────
# TODO 12: Target 'info' que imprima:
#   === $(APP_NAME) ===
#   Versión:    $(VERSION)
#   Imagen:     $(IMAGE)
#   Fecha:      $(BUILD_DATE)
#   Entorno:    $${ENV:-dev}


# ── Despliegue ─────────────────────────────────────────────────────────────────
# TODO 13: Target 'deploy-prod' que:
#   - pida confirmación: @read -p "¿Desplegar $(IMAGE) en PRODUCCIÓN? [y/N] " ans && [ "$$ans" = "y" ]
#   - luego levante el stack con docker-compose


# ── Limpieza ───────────────────────────────────────────────────────────────────
# TODO 14: Target 'clean' que elimine .venv/, cachés Python y __pycache__


help: ## Mostrar ayuda
	@echo "$(APP_NAME) — Targets disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Versión: $(VERSION)"
