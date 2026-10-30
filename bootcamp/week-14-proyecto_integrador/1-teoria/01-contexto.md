# Proyecto Integrador — Repaso y Síntesis

## ¿Por qué importa esto?

Esta semana no hay conceptos nuevos. Hay decisiones: ¿pattern rule o target explícito? ¿`include` o sub-make? ¿stamp o `.PHONY`? Cada una tiene un coste, y un build system de equipo es la suma de muchas decisiones pequeñas bien tomadas. Esta página es el mapa para tomarlas.

## Cuándo usar cada técnica

| Situación | Técnica | Semana |
|-----------|---------|:--:|
| Que un error en mitad de un pipe pare la receta | `SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c` | [03](../../week-03-shell_y_modo_estricto/README.md) |
| Que un archivo a medio escribir no parezca al día | `.DELETE_ON_ERROR:` | [03](../../week-03-shell_y_modo_estricto/README.md) |
| Borrar un directorio que viene de una variable | `$(if $(VAR),,$(error ...))` + `rm -rf -- '$(VAR)'` | [03](../../week-03-shell_y_modo_estricto/README.md) |
| Compilar N `.c` en N `.o` | Pattern rule con `$<` y `$@` | 04–05 |
| Recompilar al cambiar un header | `-MMD -MP` + `-include $(DEPS)` | [06](../../week-06-dependencias_y_targets_especiales/README.md) |
| Crear el directorio de salida sin recompilar todo | Prerrequisito *order-only* (`\| dir/`) | [06](../../week-06-dependencias_y_targets_especiales/README.md) |
| Descubrir y transformar listas de archivos | `$(wildcard)`, `$(patsubst)`, `$(foreach)` | 07–08 |
| Compartir lógica entre servicios | `include ../shared-mk/build.mk` con `?=` | 09 |
| Orquestar servicios | Un target phony por servicio con `$(MAKE) -C` | [10](../../week-10-paralelismo_y_recursion/README.md) |
| Paralelizar sin carreras | Dependencias reales, nunca el orden de la lista | [10](../../week-10-paralelismo_y_recursion/README.md) |
| Instalar dependencias solo si cambió el lockfile | Stamp que depende de manifiesto y lockfile | 11 |
| Que una imagen no corra como root | `USER` sin privilegios en el Dockerfile | 11 |
| Un pipeline idéntico en local y en CI | Target `ci`; hooks que llaman a `make check` | 12 |
| Revisar qué puede salir mal antes de publicar | Modelo de amenazas, `--warn-undefined-variables`, `make -n` | [13](../../week-13-seguridad_portabilidad_y_alternativas/README.md) |

## Stamps: el patrón más subestimado

`uv sync` no produce un archivo que Make pueda comparar. Un stamp le da una fecha:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

UV ?= uv

.stamps/:
	mkdir -p $@

.stamps/deps: pyproject.toml uv.lock | .stamps/
	$(UV) sync --locked
	touch $@
```

Ahora `uv sync` solo corre cuando `pyproject.toml` o `uv.lock` son más nuevos que el stamp. El directorio va como order-only: su fecha cambia con cada archivo que se escribe dentro y no debe forzar reinstalaciones. `UV ?= uv` permite ejecutar el pipeline sin red con `make UV=:`.

## Recursión: el fallo tiene que llegar arriba

```makefile
SERVICES := backend frontend infra

.PHONY: ci $(addsuffix /ci,$(SERVICES))
ci: $(addsuffix /ci,$(SERVICES))

$(addsuffix /ci,$(SERVICES)):
	$(MAKE) -C $(@D) $(@F)
```

Cada servicio es un nodo del grafo. Si `backend/ci` falla, `make ci` sale con error; con `-j3` los tres corren a la vez y comparten el jobserver porque la receta usa `$(MAKE)`. Un bucle `for s in ...; do $(MAKE) -C $$s; done` esconde todo eso dentro de un único comando de shell.

## `ci` con `-j`: el orden no es una dependencia

`ci: lint test build` da orden y fallo rápido solo en serie. Con `make -j` los tres arrancan a la vez. Es seguro únicamente si ninguno lee lo que otro escribe. Si `build` necesita los tests en verde, decláralo: `build: test`.

> [!NOTE]
> **Make 4.4+.** `ci: lint .WAIT test .WAIT build` fuerza el orden también con
> `-j`. En 4.3 no existe `.WAIT`: declara la dependencia real (`test: lint`,
> `build: test`).

## Ejemplo mínimo funcional

Pégalo en un directorio vacío y ejecuta `make ci`, `make ci` de nuevo (no repite `deps`) y `make clean BUILD_DIR=`.

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: ci lint test build clean help
.DEFAULT_GOAL := help

APP       := mi-servicio
BUILD_DIR ?= build
STAMPS    := $(BUILD_DIR)/.stamps

ci: lint test build ## Pipeline completo

$(STAMPS)/:
	mkdir -p $@

$(STAMPS)/deps: Makefile | $(STAMPS)/
	@echo "==> Instalando dependencias (aquí iría uv sync --locked)"
	@touch $@

lint: $(STAMPS)/deps ## Verificar estilo
	@echo "[$(APP)] Lint OK"

test: $(STAMPS)/deps ## Ejecutar tests
	@echo "[$(APP)] Tests OK"

build: test ## Construir (solo con tests en verde)
	@echo "[$(APP)] Build OK"

clean: ## Eliminar artefactos
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-build-c-completo/README.md) y ponlo en práctica.
