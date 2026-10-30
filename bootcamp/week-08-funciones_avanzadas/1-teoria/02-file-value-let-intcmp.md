# `$(file)`, `$(value)`, `$(let)`, `$(intcmp)` y el coste de `$(shell)`

## ¿Por qué importa esto?

`$(shell)` es la navaja suiza de Make, y por eso se abusa de ella: se usa para escribir archivos, para comparar números y para leer configuración. Cada llamada lanza un proceso, se ejecuta al leer el Makefile aunque pidas `make help`, y ejecuta lo que contenga la variable. Cuatro funciones hacen ese trabajo sin shell, o te ayudan a ver lo que Make está a punto de evaluar.

## Referencia rápida

| Función | Versión | Qué hace |
|---------|---------|----------|
| `$(file >ruta,texto)` | 4.0+ | Escribe `texto` + salto de línea en `ruta` (`>>` añade al final) |
| `$(file <ruta)` | 4.2+ | Devuelve el contenido de `ruta`, conservando los saltos de línea internos |
| `$(value VAR)` | 3.81+ | Devuelve el texto de `VAR` **sin expandirlo** |
| `$(let a b,lista,texto)` | 4.4+ | Asigna palabras de `lista` a `a`, `b`… solo dentro de `texto`; la última recibe el resto |
| `$(intcmp a,b,menor,igual,mayor)` | 4.4+ | Compara dos enteros y devuelve la rama que toque |

## Escribir y leer archivos sin shell

Pega esto en un directorio vacío y ejecuta `make`, luego `make clean`:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo clean
.DEFAULT_GOAL := demo

BUILD    := build
SERVICES := api worker monitor

define GREETING
Hola desde $(1)
endef

$(BUILD):
	mkdir -p $@

$(BUILD)/services.txt: | $(BUILD)
	$(file >$@,# Servicios)
	$(foreach s,$(SERVICES),$(file >>$@,$(s)))
	@echo "Escrito: $@"

demo: $(BUILD)/services.txt
	@echo "Leído:   $(strip $(file <$(BUILD)/services.txt))"
	@echo 'Crudo:   $(value GREETING)'
	@echo "Llamado: $(call GREETING,api)"

clean:
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'
```

Salida:

```
mkdir -p build
Escrito: build/services.txt
Leído:   # Servicios api worker monitor
Crudo:   Hola desde $(1)
Llamado: Hola desde api
```

Tres detalles que muerden:

- **Make expande la receta entera antes de ejecutar su primera línea.** Si pones `mkdir -p $(@D)` como primera línea y `$(file >$@,...)` después, falla con `open: build/services.txt: No such file or directory`. Por eso el directorio va como prerrequisito *order-only* (semana 06).
- `$(file)` escribe **también con `make -n`**: la función actúa al expandir, no al ejecutar.
- `$(value GREETING)` devuelve `$(1)` literal. Entre comillas dobles, bash lo interpretaría como sustitución de comando; por eso va entre comillas simples.

Una línea por elemento sin `printf` ni límite de longitud de comando: así se generan listas de objetos enormes o un `manifest.mk` incluible.

## `$(let)` y `$(intcmp)`

> [!NOTE]
> **Make 4.4+.** En Make 4.3 estas funciones **no dan error**: se tratan como una variable que no existe y expanden a vacío. Comprueba `make --version` antes de usarlas.

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo
.DEFAULT_GOAL := demo

JOBS     ?= 4
MAX_JOBS := 8
SERVICES := api worker monitor

demo:
	@echo "Primero: $(let first rest,$(SERVICES),$(first))"
	@echo "Resto:   $(let first rest,$(SERVICES),$(rest))"
	@echo "Jobs:    $(intcmp $(JOBS),$(MAX_JOBS),ok,ok,demasiados)"
```

Alternativa que funciona en 4.3 (misma salida con `make` y con `make JOBS=12`):

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo
.DEFAULT_GOAL := demo

JOBS     ?= 4
MAX_JOBS := 8
SERVICES := api worker monitor

demo:
	@echo "Primero: $(firstword $(SERVICES))"
	@echo "Resto:   $(wordlist 2,$(words $(SERVICES)),$(SERVICES))"
	@echo "Jobs:    $(shell [ $(JOBS) -le $(MAX_JOBS) ] && echo ok || echo demasiados)"
```

## `$(shell)` se ejecuta al leer el Makefile

Toda asignación con `$(shell)` corre en la fase de lectura, antes de elegir target. Pega esto y ejecuta `time make -n help` y después `make -n help TAG='v1; touch pwned'`:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help
.DEFAULT_GOAL := help

TAG ?= v1

SLOW      := $(shell sleep 2; echo listo)
TAG_CLEAN := $(shell echo $(TAG))

help: ## Muestra la ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

- **Coste:** `make -n help` tarda 2 segundos sin ejecutar nada. Con `=` en lugar de `:=` el coste se paga en cada referencia.
- **Seguridad:** el segundo comando crea el archivo `pwned` aunque pediste `-n`. Un valor de la línea de comandos, de `.env` o de un nombre de archivo llega sin comillas al shell.

Reglas: `:=` siempre con `$(shell)`; nada de `$(shell)` con variables que vengan de fuera; si solo lo necesita una receta, ponlo en la receta, donde `-n` sí lo protege.

---

Empieza por el [lab-01](../2-practicas/lab-01-foreach/README.md); el [lab-04](../2-practicas/lab-04-shell/README.md) usa `$(file)` y mide el coste de `$(shell)`.
