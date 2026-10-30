# Origen, sabor y precedencia de las variables

## ¿Por qué importa esto?

"Pasé `ENV=prod` y desplegó en `dev`." Cuando una variable no vale lo que
esperas, la pregunta no es qué vale, sino **de dónde salió** y **de qué tipo
es**. Make responde a las dos con `$(origin VAR)` y `$(flavor VAR)`: dejas de
adivinar y lo compruebas.

## Quién gana

De mayor a menor prioridad:

| Fuente | Ejemplo | `$(origin VAR)` |
|--------|---------|-----------------|
| `override` en el Makefile | `override CFLAGS += -Wall` | `override` |
| Línea de comandos | `make ENV=prod` | `command line` |
| Asignación en el Makefile (`=`, `:=`, `!=`) | `ENV := dev` | `file` |
| Variable de entorno | `ENV=prod make` | `environment` |
| `?=` (solo si nadie la definió antes) | `ENV ?= dev` | `file` |
| Variable que Make trae de serie | `CC` vale `cc` | `default` |
| Nadie | — | `undefined` |

Fíjate en el orden de las filas 3 y 4: **el entorno pierde ante una asignación
normal**. Con `ENV := dev`, exportar `ENV=prod` no sirve de nada. Con
`ENV ?= dev` sí, porque la variable ya está definida cuando `?=` mira.
`make -e` invierte esas dos filas; no lo uses como solución, usa `?=`.

## Ejemplo funcional — pega y ejecuta

```makefile
.PHONY: show
.DEFAULT_GOAL := show

ENV       ?= dev
CFLAGS    := -O2
override CFLAGS += -Wall
KERNEL    != uname -s
IMAGE_TAG  = app:$(ENV)

show:
	@echo "ENV       = $(ENV)  [origin: $(origin ENV)]"
	@echo "CFLAGS    = $(CFLAGS)  [origin: $(origin CFLAGS)]"
	@echo "KERNEL    = $(KERNEL)  [flavor: $(flavor KERNEL)]"
	@echo "IMAGE_TAG = $(IMAGE_TAG)  [flavor: $(flavor IMAGE_TAG)]"
	@echo "CC        = $(CC)  [origin: $(origin CC)]"
```

Pruébalo de tres formas:

```bash
make                    # ENV = dev   [origin: file]
ENV=prod make           # ENV = prod  [origin: environment]
make ENV=qa CFLAGS=-O0  # ENV = qa    [origin: command line]
                        # CFLAGS = -O0 -Wall  [origin: override]
```

En la última, `CFLAGS := -O2` se ignora (la CLI manda), pero
`override CFLAGS += -Wall` se aplica igualmente: así se fuerzan flags
obligatorios sin quitarle al usuario el control del resto.

## `!=`: asignación con la shell

`KERNEL != uname -s` ejecuta el comando **una vez**, al leer esa línea, igual
que `KERNEL := $(shell uname -s)`. La diferencia: `$(flavor KERNEL)` dice
`recursive`. El resultado se guarda como texto de una variable `=`, así que un
`$` en la salida del comando se expandirá al usar la variable. Con salidas que
puedan contener `$`, prefiere `:= $(shell ...)`.

## `$(flavor VAR)`

Devuelve `simple` (`:=`), `recursive` (`=`, `?=`, `!=`) o `undefined`. Es la
forma directa de comprobar el tipo real de una variable, sin leer
`make -p` entero.

> [!NOTE]
> **Make 4.4+:** `:::=` expande el lado derecho en el momento (como `:=`) pero
> crea una variable recursiva: los `+=` posteriores se añaden sin expandir. Es
> la asignación "inmediata" del estándar POSIX. En Make 4.3 provoca
> `*** empty variable name.  Stop.`; la alternativa 4.3 es `:=`, que cubre el
> mismo caso práctico (capturar el valor ya).

---

Listo. Ve al [lab-01](../2-practicas/lab-01-variables-basicas/README.md) y ponlo en práctica.
