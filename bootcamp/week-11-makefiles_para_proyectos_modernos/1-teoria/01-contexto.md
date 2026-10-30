# Makefiles para Proyectos Modernos

## ¿Por qué importa esto?

Cada ecosistema tiene su propio gestor de tareas: `pytest` para Python, `npm run` para Node.js, `docker build` para contenedores. El problema es que cada uno tiene su propia sintaxis, opciones y convenciones. Make resuelve esto siendo la capa de abstracción encima de todos ellos: cualquier desarrollador que clona el repo ejecuta `make test` y funciona, sin importar si el proyecto usa pip, yarn o Dockerfile.

## Patrón: archivo testigo (sentinel file)

El truco más importante de esta semana. Make decide si ejecutar una receta comparando fechas. Cuando un comando no produce un archivo de salida concreto (como `pip install`), creamos un archivo vacío solo para que Make pueda trackear cuándo se ejecutó por última vez:

```makefile
VENV     := .venv
PIP      := $(VENV)/bin/pip

$(VENV)/.installed: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $@           # ← crea el sentinel file al terminar

install: $(VENV)/.installed
```

Resultado: `make install` solo reinstala cuando `requirements.txt` cambia. Idéntico para `node_modules/`.

## Referencia rápida

| Ecosistema | Sentinel file | Herramienta | Patrón |
|-----------|---------------|-------------|--------|
| Python | `.venv/.installed` | pip | depende de `requirements.txt` |
| Node.js | `node_modules/.package-lock.json` | npm | depende de `package.json` |
| Docker | ninguno (imagen en registry) | docker | siempre reconstruye o usa `--cache-from` |
| docker-compose | ninguno | docker-compose | targets PHONY, orquestación |

## Variables de entorno desde `.env`

```makefile
# -include (con guion) no falla si .env no existe
-include .env
export   # propaga todas las variables al shell de las recetas
```

## Ejemplo mínimo funcional

Pega esto en un directorio vacío y ejecuta `make info`:

```makefile
.PHONY: all install test clean info help
.DEFAULT_GOAL := help

PYTHON   := python3
VENV     := .venv
PIP      := $(VENV)/bin/pip
PYTEST   := $(VENV)/bin/pytest
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

-include .env
export

$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PIP) install -r requirements.txt
	@touch $@

install: $(VENV)/.installed ## Instalar dependencias

test: install ## Ejecutar tests
	$(PYTEST) tests/ -v

info: ## Mostrar información del proyecto
	@echo "Versión:  $(VERSION)"
	@echo "Python:   $(shell $(PYTHON) --version 2>&1)"
	@echo "Venv:     $(VENV)"

clean: ## Eliminar artefactos
	@rm -rf $(VENV) __pycache__ .pytest_cache
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

> **Nota:** si no tienes un `requirements.txt`, créalo vacío con `touch requirements.txt` antes de ejecutar `make install`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-python/README.md) y ponlo en práctica.
