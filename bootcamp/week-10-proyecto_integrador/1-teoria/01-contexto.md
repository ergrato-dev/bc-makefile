# Proyecto Integrador — Repaso y Síntesis

## ¿Por qué importa esto?

Sabes usar Make. Esta semana dejas de usar Make en labs aislados y construyes algo que un equipo real usaría. La integración exige tomar decisiones: ¿pattern rule o target explícito? ¿`include` o submake recursivo? ¿`.stamp` o `.PHONY`? No hay una respuesta única — hay trade-offs. Esta teoría te da el mapa para decidir.

## Cuándo usar cada técnica

| Situación | Técnica | Semana de origen |
|-----------|---------|-----------------|
| Compilar N archivos `.c` → `.o` | Pattern rules + `$<` `$@` | 03–04 |
| Descubrir fuentes automáticamente | `$(wildcard ...)` | 05 |
| Transformar listas de archivos | `$(patsubst ...)` `$(addprefix ...)` | 05 |
| Lógica reutilizable entre targets | `$(call fn, arg)` | 06 |
| Adaptar a `dev`/`staging`/`prod` | `ifeq` / `ifdef` | 09 |
| Compartir lógica entre proyectos | `include shared-mk/build.mk` | 09 |
| Orquestar múltiples servicios | `$(MAKE) -C servicio` | 09 |
| Marcar tareas sin artefacto natural | archivo `.stamp` | 05 |
| Tareas siempre ejecutables | `.PHONY` | 01 |
| Pipeline en un comando | target `ci` que llama a otros | 08 |

## Stamps: el patrón más subestimado

Cuando un target no produce un archivo concreto (ej: `pip install`), Make no puede saber si está al día. La solución es un archivo stamp:

```makefile
.stamps/:
	mkdir -p .stamps

.stamps/deps: requirements.txt | .stamps/
	pip install -r requirements.txt
	touch $@

test: .stamps/deps ## Ejecutar tests (instala deps si es necesario)
	pytest tests/
```

Ahora `pip install` solo corre cuando `requirements.txt` cambia. Sin stamp, correría en cada `make test`.

## El target `ci`: punto de entrada del pipeline

```makefile
.PHONY: ci lint test build-image

ci: lint test build-image ## Pipeline completo (lint → test → build)

lint: ## Verificar estilo del código
	@echo "==> Lint"
	flake8 src/ --max-line-length=100

test: .stamps/deps ## Ejecutar suite de tests
	@echo "==> Tests"
	pytest tests/ -v --tb=short

build-image: ## Construir imagen Docker
	@echo "==> Build Docker"
	docker build --tag $(IMAGE_NAME):$(VERSION) .
```

La secuencia `lint test build-image` como dependencias de `ci` garantiza orden y fallo rápido: si `lint` falla, `test` no corre. Cada target es independientemente invocable.

## Ejemplo mínimo funcional

```makefile
.PHONY: all ci lint test clean help
.DEFAULT_GOAL := help

APP     := mi-servicio
VERSION := $(shell git describe --tags --always 2>/dev/null || echo 0.1.0)
ENV     ?= development
PYTHON  := python3

-include .env

.stamps/:
	mkdir -p $@

.stamps/deps: requirements.txt | .stamps/
	$(PYTHON) -m pip install -r $< -q
	touch $@

all: ci ## Ejecutar pipeline completo

ci: lint test ## Lint + tests

lint: ## Verificar estilo
	@$(PYTHON) -m flake8 src/ --max-line-length=100

test: .stamps/deps ## Ejecutar tests
	@$(PYTHON) -m pytest tests/ -q

clean: ## Eliminar artefactos
	rm -rf .stamps/ __pycache__ .pytest_cache

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-build-c-completo/README.md) y ponlo en práctica.
