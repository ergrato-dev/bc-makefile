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

Dos reglas hacen que el sentinel no mienta. Primera: el target es un archivo, no el directorio `.venv/`, porque la fecha de un directorio cambia con cualquier cosa que se cree dentro y porque un `uv sync` fallido a mitad deja el directorio creado. Segunda: las herramientas se ejecutan con `uv run --no-sync`. Sin el flag, uv volvería a sincronizar el entorno por su cuenta y habría dos sistemas decidiendo cuándo instalar.

## Calidad: ruff

**ruff** es linter y formateador en un solo binario, fijado en el grupo `dev` de `pyproject.toml` (`ruff==0.16.10`). Dos subcomandos, dos targets:

```makefile
lint: install
	uv run --no-sync ruff check src/

format: install
	uv run --no-sync ruff format src/ tests/
```

`ruff format` reescribe archivos: es para tu máquina. En CI usas `ruff format --check`, que no toca nada y sale con error si algo cambiaría. Un target sin receta como `check: format-check lint test` agrupa todo lo que debe pasar antes de integrar.

## Referencia rápida

| Ecosistema | Sentinel file | Herramienta | Patrón |
|-----------|---------------|-------------|--------|
| Python | `.venv/.installed` | uv | depende de `pyproject.toml` y `uv.lock` |
| Node.js | `node_modules/.installed` | pnpm install --frozen-lockfile | depende de `package.json` y `pnpm-lock.yaml` |
| Docker | `.build/<imagen>.iid` | `docker build --iidfile` | depende de `Dockerfile` y del código copiado |
| Compose v2 | ninguno | `docker compose` | targets PHONY, orquestación |

## Variables de entorno desde `.env`

```makefile
# -include (con guion) no falla si .env no existe
-include .env
export ENV DATABASE_URL   # solo lo que las recetas necesitan
```

Nunca `export` a secas: manda todas las variables, secretos incluidos, a cada proceso. Y `.env` se parsea como Makefile: `$` se expande, las comillas quedan literales y `#` corta el valor.

## Ejemplo mínimo funcional

Pega esto como `Makefile` en un directorio vacío y ejecuta `make` y `make info`. Para el resto de targets necesitas un proyecto uv (ver la nota al final):

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install test lint clean info help
.DEFAULT_GOAL := help

UV       := uv
VENV     := .venv
# --no-sync: Make decide cuándo instalar; uv run solo ejecuta
PYTEST   := $(UV) run --no-sync pytest
RUFF     := $(UV) run --no-sync ruff
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

# .env se parsea como Makefile: valores sin $, sin comillas y sin #
-include .env
ENV ?= dev
export ENV

$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias

test: install ## Ejecutar tests
	$(PYTEST) tests/ -v

lint: install ## Analizar con ruff
	$(RUFF) check .

info: ## Mostrar información del proyecto
	@echo "Versión:  $(VERSION)"
	@echo "uv:       $(shell $(UV) --version 2>&1)"
	@echo "Venv:     $(VENV)"
	@echo "Entorno:  $$ENV"

clean: ## Eliminar artefactos
	$(if $(VENV),,$(error VENV vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(VENV)' __pycache__ .pytest_cache .ruff_cache
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

> **Nota:** para probar `install`, `test` y `lint`, crea el proyecto con `uv init --bare && uv add --dev pytest ruff==0.16.10` (genera `pyproject.toml` y `uv.lock`) y un `tests/test_ok.py` con `def test_ok(): assert True`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-python/README.md) y ponlo en práctica.
