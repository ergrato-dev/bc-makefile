.PHONY: all install install-dev test lint run build docker-run up down info deploy-prod clean help
.DEFAULT_GOAL := help

# ── Configuración ──────────────────────────────────────────────────────────────
APP_NAME   := notificador
UV         := uv
VENV       := .venv
# --no-sync: Make decide cuándo instalar (sentinel); uv run solo ejecuta
RUN        := $(UV) run --no-sync
PYTEST     := $(RUN) pytest
FLAKE8     := $(RUN) flake8

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
# TODO A: Agrega '-include .env' y exporta SOLO las variables que lee la app:
#         export ENV LOG_LEVEL SMTP_HOST SMTP_PORT
#         Nunca `export` a secas: mandaría todo a cada subproceso.


# ── Instalación ────────────────────────────────────────────────────────────────
# TODO 1: Target '$(VENV)/.installed' con dependencias pyproject.toml y uv.lock
#   - $(UV) sync --locked --no-dev --inexact   (solo runtime; --inexact no
#     desinstala las herramientas de dev si ya estaban)
#   - termina con @touch $@


# TODO 2: Target '$(VENV)/.installed-dev' con dependencia $(VENV)/.installed
#   - $(UV) sync --locked   (runtime + grupo dev de pyproject.toml)
#   - termina con @touch $@


# TODO 3: Target 'install' como alias de '$(VENV)/.installed' con comentario ##


# TODO 4: Target 'install-dev' como alias de '$(VENV)/.installed-dev' con comentario ##


# ── Calidad ────────────────────────────────────────────────────────────────────
# TODO 5: Target 'test' que dependa de 'install-dev' y ejecute $(PYTEST) tests/ -v


# TODO 6: Target 'lint' que dependa de 'install-dev' y ejecute $(FLAKE8) src/ --max-line-length=100


# ── Ejecución ──────────────────────────────────────────────────────────────────
# TODO 7: Target 'run' que dependa de 'install' y ejecute $(RUN) python src/main.py


# ── Docker ─────────────────────────────────────────────────────────────────────
# TODO 8: Target 'build' que:
#   - ejecute docker build con --build-arg VERSION=$(VERSION) y --build-arg BUILD_DATE=$(BUILD_DATE)
#   - etiquete como $(APP_NAME):$(VERSION) (sin latest: es mutable)
#   - imprima "Imagen: $(IMAGE)" al terminar


# TODO 9: Target 'docker-run' que ejecute $(IMAGE) con --rm y --env-file .env


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
#   - pida confirmación de forma portable (read -p no existe en dash/POSIX):
#       @printf '¿Desplegar $(IMAGE) en PRODUCCIÓN? [y/N] '; read -r ans; [ "$$ans" = "y" ]
#   - luego levante el stack con $(COMPOSE)


# ── Limpieza ───────────────────────────────────────────────────────────────────
# TODO 14: Target 'clean' que elimine .venv/, cachés Python y __pycache__


help: ## Mostrar ayuda
	@echo "$(APP_NAME) — Targets disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Versión: $(VERSION)"
