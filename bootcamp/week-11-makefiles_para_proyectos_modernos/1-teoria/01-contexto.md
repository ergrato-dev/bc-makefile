# Makefiles para Proyectos Modernos

## ¿Por qué importa esto?

Cada ecosistema tiene su propio gestor de tareas: `pytest` para Python, `pnpm run` para Node.js, `docker build` para contenedores. El problema es que cada uno tiene su propia sintaxis, opciones y convenciones. Make resuelve esto siendo la capa de abstracción encima de todos ellos: cualquier desarrollador que clona el repo ejecuta `make test` y funciona, sin importar si el proyecto usa uv, pnpm o Dockerfile.

## Patrón: archivo testigo (sentinel file)

El truco más importante de esta semana. Make decide si ejecutar una receta comparando fechas. Cuando un comando no produce un archivo de salida concreto (como `uv sync`), creamos un archivo vacío solo para que Make pueda trackear cuándo se ejecutó por última vez:

```makefile
VENV     := .venv

$(VENV)/.installed: pyproject.toml uv.lock
	uv sync --locked    # crea .venv/ e instala lo que dice uv.lock
	@touch $@           # ← crea el sentinel file al terminar

install: $(VENV)/.installed
```

Resultado: `make install` solo reinstala cuando `pyproject.toml` o `uv.lock` cambian. Idéntico para `node_modules/`.

Python se gestiona siempre con **uv**, nunca con pip: `pyproject.toml` declara las dependencias, `uv.lock` las fija y se commitea, `uv sync --locked` instala exactamente eso (y falla si el lock no coincide con `pyproject.toml`).

## Referencia rápida

| Ecosistema | Sentinel file | Herramienta | Patrón |
|-----------|---------------|-------------|--------|
| Python | `.venv/.installed` | uv | depende de `pyproject.toml` y `uv.lock` |
| Node.js | `node_modules/.installed` | pnpm install --frozen-lockfile | depende de `package.json` y `pnpm-lock.yaml` |
| Docker | ninguno (imagen en registry) | docker | siempre reconstruye o usa `--cache-from` |
| Compose v2 | ninguno | `docker compose` | targets PHONY, orquestación |

## Variables de entorno desde `.env`

```makefile
# -include (con guion) no falla si .env no existe
-include .env
export ENV DATABASE_URL   # solo lo que las recetas necesitan
```

Nunca `export` a secas: manda todas las variables, secretos incluidos, a cada proceso. Y `.env` se parsea como Makefile: `$` se expande, las comillas quedan literales y `#` corta el valor.

## Ejemplo mínimo funcional

Pega esto en un directorio vacío y ejecuta `make info`:

```makefile
.PHONY: all install test clean info help
.DEFAULT_GOAL := help

UV       := uv
VENV     := .venv
# --no-sync: Make decide cuándo instalar; uv run solo ejecuta
PYTEST   := $(UV) run --no-sync pytest
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

-include .env
export ENV

$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias

test: install ## Ejecutar tests
	$(PYTEST) tests/ -v

info: ## Mostrar información del proyecto
	@echo "Versión:  $(VERSION)"
	@echo "uv:       $(shell $(UV) --version 2>&1)"
	@echo "Venv:     $(VENV)"

clean: ## Eliminar artefactos
	@rm -rf $(VENV) __pycache__ .pytest_cache
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

> **Nota:** si el directorio no tiene proyecto Python, créalo antes con `uv init --bare && uv add --dev pytest` (genera `pyproject.toml` y `uv.lock`).

---

Listo. Ve al [lab-01](../2-practicas/lab-01-python/README.md) y ponlo en práctica.
