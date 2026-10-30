# Glosario — Semana 11

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| sentinel file | Archivo vacío que la receta crea al terminar bien para que Make sepa cuándo se ejecutó | `$(VENV)/.installed: pyproject.toml uv.lock` + `@touch $@` |
| uv | Gestor de proyectos Python: crea `.venv/`, resuelve dependencias y las fija en `uv.lock` | `$(UV) sync --locked` |
| `uv sync --locked` | Instala exactamente `uv.lock` y falla si no coincide con `pyproject.toml` | `$(UV) sync --locked --no-dev --inexact` |
| `uv run --no-sync` | Ejecuta una herramienta del entorno sin que uv lo reinstale: el sentinel ya decidió | `PYTEST := $(UV) run --no-sync pytest` |
| ruff | Linter y formateador de Python en un único binario, fijado en el grupo `dev` | `RUFF := $(RUN) ruff` |
| `ruff format --check` | Comprueba el formato sin escribir; sale con error si algo cambiaría | `format-check: ; $(RUFF) format --check src/ tests/` |
| `pnpm install --frozen-lockfile` | Instala exactamente `pnpm-lock.yaml` y falla si no coincide con `package.json` | `cd frontend && $(PNPM) install --frozen-lockfile` |
| `--build-arg` | Pasa un valor a un `ARG` del Dockerfile durante `docker build` | `--build-arg VERSION=$(VERSION)` |
| `--iidfile` | Escribe el ID de la imagen en un archivo que Make sí puede comparar por fecha | `docker build --iidfile $@ .` |
| `USER` (Dockerfile) | Fija el usuario no-root con el que corre el proceso del contenedor | `USER app` |
| Compose v2 | `docker compose`, plugin de Docker; `docker-compose` (v1) está en EOL desde 2023 | `COMPOSE := docker compose` |
| `-include .env` | Incluye `.env` si existe, **parseándolo como Makefile** (`$` se expande, `#` corta) | `-include .env` |
| `export` con lista | Pasa al entorno de las recetas solo las variables nombradas; nunca `export` a secas | `export ENV LOG_LEVEL` |
| puerta de CI | Target sin receta que agrupa las comprobaciones que deben pasar antes de integrar | `check: format-check lint test` |
