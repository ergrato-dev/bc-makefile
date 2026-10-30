# Glosario — Semana 11

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| sentinel file | Archivo vacío creado al final de una receta para que Make rastree cuándo se ejecutó | `$(VENV)/.installed: pyproject.toml uv.lock` → `@touch $@` |
| `$(VENV)/.installed` | Nombre convencional del sentinel file de un virtualenv Python | `install: $(VENV)/.installed` |
| uv | Gestor de proyectos Python: crea `.venv/`, resuelve y fija dependencias en `uv.lock` | `uv sync --locked` |
| `--build-arg` | Flag de `docker build` para pasar variables al Dockerfile como `ARG` | `docker build --build-arg VERSION=$(VERSION) .` |
| `ARG` (Dockerfile) | Variable recibida desde el exterior durante `docker build` | `ARG VERSION=unknown` |
| `LABEL` (Dockerfile) | Metadatos embebidos en la imagen Docker, consultables con `docker inspect` | `LABEL version="${VERSION}"` |
| `-include` | Directiva Make que incluye un archivo ignorando el error si no existe | `-include .env` |
| `export` | Directiva Make que propaga todas las variables al shell de las recetas | `export` (línea sola) |
| docker-compose | Herramienta para definir y ejecutar aplicaciones multi-contenedor | `docker compose up -d` |
| `COMPOSE` | Variable Make que detecta si usar `docker compose` (v2) o `docker-compose` (v1) | `COMPOSE := $(shell docker compose version >/dev/null 2>&1 && echo "docker compose" \|\| echo "docker-compose")` |
| `?=` en Make | Asigna solo si la variable no está definida — útil para parámetros con default sobreescribibles | `SERVICE ?= web` |
| `--env-file` | Flag de `docker run` para cargar variables desde un archivo `.env` | `docker run --env-file .env $(IMAGE)` |
| `read -p` en receta | Comando bash que pide confirmación interactiva al usuario antes de continuar | `@read -p "¿Continuar? [y/N] " ans && [ "$$ans" = "y" ]` |
| `$$` en recetas | Escape para usar `$` de bash dentro de una receta Make (Make consume el primero) | `[ "$$ans" = "y" ]` |
