# Trampas y utilidades: subst, strip, filter y compañía

## ¿Por qué importa esto?

Las funciones de texto casi nunca fallan con un error. Devuelven una cadena vacía o una palabra deformada, y el fallo aparece tres reglas más allá como `No rule to make target` o un `rm` sobre la ruta equivocada. Cinco trampas explican la mayoría de esos bugs.

## 1. `subst` no sabe de palabras; `patsubst` sí

`subst` reemplaza cada aparición del texto, también a mitad de un nombre. `patsubst` compara cada palabra completa con el patrón y deja intactas las que no casan. La *referencia de sustitución* `$(VAR:a=b)` es un atajo de `patsubst`.

| Expresión | Resultado |
|---|---|
| `$(subst src,release,src/srcmap.c)` | `release/releasemap.c` |
| `$(patsubst src/%,release/%,src/srcmap.c)` | `release/srcmap.c` |
| `$(patsubst %.c,%.o,main.c README.md)` | `main.o README.md` |
| `$(SRCS:src/%.c=build/%.o)` | igual que `$(patsubst src/%.c,build/%.o,$(SRCS))` |

Para extensiones y prefijos de ruta, `patsubst`. `subst` queda para caracteres sueltos (`-` → `_`).

## 2. Los espacios tras las comas cuentan

En `subst` y `patsubst` el espacio que sigue a la coma forma parte del argumento. `$(subst .c, .d,src/main.c)` devuelve `src/main .d`: **dos** palabras. Regla práctica: nunca escribas espacios después de las comas de una función.

## 3. `strip` y los espacios invisibles

Make conserva los espacios entre el valor y un comentario al final de la línea:

```makefile
OUT_DIR := out    # directorio de salida
```

`$(OUT_DIR)/app` vale `out    /app`. Pon el comentario en su propia línea. Cuando el valor viene de fuera (línea de comandos, entorno), no controlas los espacios: `make objs 'MODULE= logger '` llega con un espacio al final. `$(strip ...)` quita los espacios de los extremos y deja uno solo entre palabras; aplícalo antes de construir rutas o patrones con ese valor.

## 4. `filter` compara palabras completas

- Sin `%`, un patrón es literal: `$(filter .c,main.c)` y `$(filter utils,src/utils.c)` devuelven vacío.
- Varios patrones en un `filter` son un **o**: `$(filter src/% %.h,...)` es la unión. Para un **y** usa un solo patrón: `build/%.o`.
- `$(filter palabra,lista)` devuelve `palabra` si está en la lista y vacío si no. Es la forma idiomática de preguntar "¿está en la lista?" dentro de un `$(if)`.

## 5. `notdir` y la barra final

Para `notdir`, todo hasta la última `/` es directorio. `$(notdir modules/auth/)` devuelve **vacío**. Para sacar el nombre de un directorio, quita antes la barra: `$(notdir $(patsubst %/,%,modules/auth/))` → `auth`. De paso: `$(dir main.c)` devuelve `./`, nunca vacío, y `$(suffix archivo.tar.gz)` es `.gz`.

## Ejemplo funcional

Pega y ejecuta `make`; luego `make MODULE=nope` y `make MODULE=' logger '`:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo
.DEFAULT_GOAL := demo

DIRS    := modules/auth/ modules/logger/ modules/auth/
MODULES := $(notdir $(patsubst %/,%,$(sort $(DIRS))))
MODULE  ?= logger
MOD     := $(strip $(MODULE))

demo:
	$(if $(filter $(MOD),$(MODULES)),,$(error '$(MOD)' no existe; disponibles: $(MODULES)))
	@echo "Módulos:   $(MODULES) ($(words $(MODULES)))"
	@echo "Primero:   $(firstword $(MODULES)) / último: $(lastword $(MODULES))"
	@echo "Elegido:   [$(MOD)] en build/modules/$(MOD)/"
	@echo "subst:     $(subst .c, .d,src/main.c) ($(words $(subst .c, .d,src/main.c)) palabras)"
```

```
$ make
Módulos:   auth logger (2)
Primero:   auth / último: logger
Elegido:   [logger] en build/modules/logger/
subst:     src/main .d (2 palabras)
$ make MODULE=nope
Makefile:14: *** 'nope' no existe; disponibles: auth logger.  Stop.
```

`$(sort)` eliminó el `modules/auth/` repetido, `$(strip)` limpió el argumento y `$(filter)` hizo de guarda.

---

Ahora sí: [lab-01](../2-practicas/lab-01-wildcard/README.md), y en el [lab-06](../2-practicas/lab-06-funciones-rotas/README.md) cazarás estas trampas en un Makefile heredado.
