# Contexto — Variables y Expansión en Make

## ¿Por qué importa esto?

Un Makefile con strings repetidos es un Makefile frágil. Si cambias el nombre del compilador en cinco lugares y te olvidas del sexto, tienes un bug silencioso. Las variables resuelven eso, pero Make tiene cuatro operadores de asignación con comportamientos distintos. Elegir el incorrecto produce bugs que solo aparecen bajo condiciones específicas — y que son difíciles de rastrear porque el error no está en la receta sino en cuándo se evaluó la variable.

## Los cuatro operadores

| Operador | Nombre | Cuándo se expande | Regla práctica |
|----------|--------|-------------------|----------------|
| `=`  | Recursiva (lazy) | Al usar la variable | Usa si dependes de variables definidas después |
| `:=` | Simple (inmediata) | Al asignar | Usa siempre que puedas; es predecible |
| `?=` | Condicional | Al usar (crea una variable recursiva) | Usa para defaults sobreescribibles; solo asigna si la variable no está definida (vacía cuenta como definida) |
| `+=` | Append | Hereda el tipo original | Usa para acumular listas de flags o archivos |

## Ejemplo funcional — pega y ejecuta

```makefile
.PHONY: info help

.DEFAULT_GOAL := help

# := captura el valor de shell una sola vez al cargar el Makefile
BUILD_DATE := $(shell date +%F)

# ?= permite sobreescribir desde CLI sin modificar el archivo
ENV        ?= dev
VERSION    ?= 0.1.0

# = se evalúa en el momento de uso; puede referenciar ENV aunque cambie
IMAGE_TAG   = myapp:$(VERSION)-$(ENV)

# += acumula flags
CFLAGS     := -Wall
CFLAGS     += -Wextra

## info: muestra configuración actual
info:
	@echo "Fecha build: $(BUILD_DATE)"
	@echo "Entorno:     $(ENV)"
	@echo "Versión:     $(VERSION)"
	@echo "Imagen:      $(IMAGE_TAG)"
	@echo "CFLAGS:      $(CFLAGS)"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target] [ENV=dev|prod] [VERSION=x.y.z]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
```

Ejecuta y observa:

```bash
make info                          # usa defaults
make info ENV=prod VERSION=2.0.0   # sobreescribe desde CLI
ENV=staging make info              # sobreescribe con variable de entorno
```

## La trampa de = con $(shell ...)

```makefile
# PELIGROSO: el comando se ejecuta cada vez que se usa LOG_TIME
LOG_TIME  = $(shell date +%T)

# CORRECTO: el comando se ejecuta una sola vez al cargar el Makefile
START_TIME := $(shell date +%T)
```

Con `=` y `$(shell ...)`, Make re-ejecuta el comando de shell cada vez que expande la variable. Usa `:=` para capturar valores de shell exactamente una vez.

## Sobreescribir desde CLI

```bash
make ENV=prod deploy        # ENV vale "prod" en todos los targets
make CC=clang CFLAGS=-O2    # pasa múltiples variables
```

Las variables de CLI tienen mayor precedencia que `=`, `:=` y `?=`, pero no superan a `override`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-variables-basicas/README.md) y ponlo en práctica.
